import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nome = TextEditingController();
  final sobrenome = TextEditingController();
  final login = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool carregando = false;

  Future<void> registrar() async {
    if (nome.text.isEmpty ||
        sobrenome.text.isEmpty ||
        login.text.isEmpty ||
        email.text.isEmpty ||
        senha.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    setState(() {
      carregando = true;
    });

    final ok = await AuthService.registrar(
      nome: nome.text,
      sobrenome: sobrenome.text,
      login: login.text,
      email: email.text,
      senha: senha.text,
    );

    setState(() {
      carregando = false;
    });

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao cadastrar usuário")),
      );
    }
  }

  @override
  void dispose() {
    nome.dispose();
    sobrenome.dispose();
    login.dispose();
    email.dispose();
    senha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar conta"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF001A0F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Image.asset('assets/omnidex2.png', height: 120),

                const SizedBox(height: 30),

                TextField(
                  controller: nome,
                  decoration: const InputDecoration(
                    hintText: "Nome",
                    filled: true,
                    fillColor: Color(0xFF0A0A0A),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: sobrenome,
                  decoration: const InputDecoration(
                    hintText: "Sobrenome",
                    filled: true,
                    fillColor: Color(0xFF0A0A0A),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: login,
                  decoration: const InputDecoration(
                    hintText: "Login",
                    filled: true,
                    fillColor: Color(0xFF0A0A0A),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
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
                    onPressed: carregando ? null : registrar,
                    child: carregando
                        ? const CircularProgressIndicator()
                        : const Text("CADASTRAR"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}