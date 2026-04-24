import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final senha = TextEditingController();

  void login() async {
    final ok = await AuthService.login(email.text, senha.text);

    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login inválido")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF001A0F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/omnidex2.png', height: 140),
                const SizedBox(height: 40),

                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    filled: true,
                    fillColor: Color(0xFF0A0A0A),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: senha,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Senha",
                    filled: true,
                    fillColor: Color(0xFF0A0A0A),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text("LOGIN"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}