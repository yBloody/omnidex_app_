import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> login(String email, String senha) async {
    if (email == "email" && senha == "123") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", "jwt_fake_token");
      return true;
    }
    return false;
  }

  static Future<bool> isLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }
}