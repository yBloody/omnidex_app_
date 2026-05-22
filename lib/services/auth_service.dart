import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      "https://mobile-ios-login.zani0x03.eti.br/api";

  static const String sistemaId =
      "72f6483d-e23a-4aa3-ac39-8517baa7dc27";

  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
          "sistemaId": sistemaId,
        }),
      );

      print("STATUS LOGIN: ${response.statusCode}");
      print("BODY LOGIN: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data["access_token"] ??
            data["token"] ??
            data["accessToken"] ??
            data["jwt"] ??
            data["bearer"] ??
            data["data"]?["token"] ??
            "";

        print("TOKEN SALVO: $token");

        if (token.toString().isEmpty) {
          return false;
        }

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("token", token.toString());
        await prefs.setString("username", username);

        return true;
      }

      return false;
    } catch (e) {
      print("ERRO LOGIN: $e");
      return false;
    }
  }

  static Future<bool> registrar({
    required String nome,
    required String sobrenome,
    required String login,
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": nome,
          "surname": sobrenome,
          "login": login,
          "email": email,
          "password": senha,
          "sistemaId": sistemaId,
        }),
      );

      print("STATUS CADASTRO: ${response.statusCode}");
      print("BODY CADASTRO: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("ERRO CADASTRO: $e");
      return false;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    print("TOKEN PEGADO: $token");

    return token;
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("username");
  }

  static Future<bool> isLogado() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}