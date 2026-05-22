import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';

class SuportePage extends StatefulWidget {
  const SuportePage({super.key});

  @override
  State<SuportePage> createState() => _SuportePageState();
}

class _SuportePageState extends State<SuportePage> {
  final TextEditingController mensagemController = TextEditingController();

  final List<Map<String, String>> mensagens = [
    {
      "tipo": "ia",
      "texto": "Olá! Sou o suporte IA do Omnidex. Como posso ajudar?",
    },
  ];

  bool carregando = false;

  Future<void> enviarMensagem() async {
    final mensagem = mensagemController.text.trim();

    if (mensagem.isEmpty || carregando) return;

    setState(() {
      mensagens.add({
        "tipo": "usuario",
        "texto": mensagem,
      });
      carregando = true;
    });

    mensagemController.clear();

    try {
      final token = await AuthService.getToken();

      print("TOKEN USADO NA IA: $token");

      if (token == null || token.isEmpty) {
        setState(() {
          mensagens.add({
            "tipo": "ia",
            "texto": "Você precisa fazer login novamente.",
          });
        });
        return;
      }

      final response = await http.post(
        Uri.parse("https://mobile-ios-ia.zani0x03.eti.br/api/ai/chat"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "prompt": mensagem,
        }),
      );

      print("STATUS IA: ${response.statusCode}");
      print("BODY IA: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final resposta = data["response"] ??
            data["message"] ??
            data["resposta"] ??
            data["answer"] ??
            data["content"] ??
            data["data"]?["response"] ??
            data["data"]?["message"] ??
            response.body;

        setState(() {
          mensagens.add({
            "tipo": "ia",
            "texto": resposta.toString(),
          });
        });
      } else if (response.statusCode == 401) {
        setState(() {
          mensagens.add({
            "tipo": "ia",
            "texto":
                "Erro 401: seu token não foi aceito. Faça logout, entre de novo e teste novamente.",
          });
        });
      } else {
        setState(() {
          mensagens.add({
            "tipo": "ia",
            "texto": "Erro ao chamar a IA. Código: ${response.statusCode}",
          });
        });
      }
    } catch (e) {
      print("ERRO IA: $e");

      setState(() {
        mensagens.add({
          "tipo": "ia",
          "texto": "Erro de conexão com a IA.",
        });
      });
    } finally {
      setState(() {
        carregando = false;
      });
    }
  }

  Widget bolhaMensagem(Map<String, String> mensagem) {
    final bool usuario = mensagem["tipo"] == "usuario";

    return Align(
      alignment: usuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: usuario ? Colors.greenAccent : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          mensagem["texto"] ?? "",
          style: TextStyle(
            color: usuario ? Colors.black : Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    mensagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suporte IA"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF001A0F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: mensagens.length,
                itemBuilder: (context, index) {
                  return bolhaMensagem(mensagens[index]);
                },
              ),
            ),
            if (carregando)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: CircularProgressIndicator(),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: mensagemController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Digite sua mensagem...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => enviarMensagem(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: carregando ? null : enviarMensagem,
                    icon: const Icon(Icons.send),
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}