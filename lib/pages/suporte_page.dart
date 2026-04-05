import 'package:flutter/material.dart';

class SuportePage extends StatefulWidget {
  const SuportePage({super.key});

  @override
  State<SuportePage> createState() => _SuportePageState();
}

class _SuportePageState extends State<SuportePage> {
  final TextEditingController mensagemController = TextEditingController();

  final List<Map<String, String>> mensagens = [
    {
      'autor': 'suporte',
      'texto': 'Bem-vindo ao suporte da OmniDex! Como podemos ajudar?'
    },
    {
      'autor': 'suporte',
      'texto': 'Você pode tirar dúvidas sobre produtos, pedidos e pagamentos.'
    },
  ];

  void enviarMensagem() {
    if (mensagemController.text.trim().isEmpty) return;

    setState(() {
      mensagens.add({
        'autor': 'usuario',
        'texto': mensagemController.text.trim(),
      });

      mensagens.add({
        'autor': 'suporte',
        'texto': 'Recebemos sua mensagem. Em breve retornaremos com mais detalhes.',
      });
    });

    mensagemController.clear();
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
        title: const Text('Suporte / Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mensagens.length,
              itemBuilder: (context, index) {
                final msg = mensagens[index];
                final isUsuario = msg['autor'] == 'usuario';

                return Align(
                  alignment:
                      isUsuario ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: isUsuario
                          ? const Color(0xFF0A84FF)
                          : const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg['texto'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            color: const Color(0xFF111827),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: mensagemController,
                    decoration: const InputDecoration(
                      hintText: 'Digite sua mensagem...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: enviarMensagem,
                  icon: const Icon(Icons.send, color: Color(0xFF0A84FF)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}