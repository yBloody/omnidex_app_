import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/database_helper.dart';

class FinalizarCompraPage extends StatefulWidget {
  final List<Map<String, dynamic>> itens;
  final double total;

  const FinalizarCompraPage({
    super.key,
    required this.itens,
    required this.total,
  });

  @override
  State<FinalizarCompraPage> createState() => _FinalizarCompraPageState();
}

class _FinalizarCompraPageState extends State<FinalizarCompraPage> {
  final nome = TextEditingController();
  final endereco = TextEditingController();
  final telefone = TextEditingController();

  String pagamento = "Pix";

  final formato = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  Future<void> finalizarCompra() async {
    if (nome.text.isEmpty || endereco.text.isEmpty || telefone.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    await DatabaseHelper.limparCarrinho();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0A0A0A),
          title: const Text("Compra finalizada"),
          content: Text(
            "Obrigado, ${nome.text}!\n\nSeu pedido foi confirmado com pagamento via $pagamento.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nome.dispose();
    endereco.dispose();
    telefone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frete = widget.total >= 200 ? 0.0 : 19.90;
    final totalFinal = widget.total + frete;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizar compra"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF001A0F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Resumo do pedido",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...widget.itens.map((item) {
              final qtd = item['quantidade'] as int;
              final preco = (item['preco'] as num).toDouble();

              return Card(
                color: const Color(0xFF0A0A0A),
                child: ListTile(
                  leading: Image.network(
                    item['imagem'],
                    width: 45,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                  title: Text(
                    item['nome'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text("Quantidade: $qtd"),
                  trailing: Text(
                    formato.format(preco * qtd),
                    style: const TextStyle(color: Color(0xFF00FF88)),
                  ),
                ),
              );
            }),

            const SizedBox(height: 18),

            Card(
              color: const Color(0xFF0A0A0A),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    linhaResumo("Produtos", formato.format(widget.total)),
                    linhaResumo("Frete", frete == 0 ? "Grátis" : formato.format(frete)),
                    const Divider(),
                    linhaResumo(
                      "Total",
                      formato.format(totalFinal),
                      destaque: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              "Dados de entrega",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            campoTexto(nome, "Nome completo", Icons.person),
            campoTexto(endereco, "Endereço de entrega", Icons.location_on),
            campoTexto(telefone, "Telefone", Icons.phone),

            const SizedBox(height: 18),

            const Text(
              "Forma de pagamento",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            RadioListTile(
              value: "Pix",
              groupValue: pagamento,
              onChanged: (value) {
                setState(() => pagamento = value.toString());
              },
              title: const Text("Pix"),
              activeColor: const Color(0xFF00FF88),
            ),

            RadioListTile(
              value: "Cartão de crédito",
              groupValue: pagamento,
              onChanged: (value) {
                setState(() => pagamento = value.toString());
              },
              title: const Text("Cartão de crédito"),
              activeColor: const Color(0xFF00FF88),
            ),

            RadioListTile(
              value: "Boleto",
              groupValue: pagamento,
              onChanged: (value) {
                setState(() => pagamento = value.toString());
              },
              title: const Text("Boleto"),
              activeColor: const Color(0xFF00FF88),
            ),

            const SizedBox(height: 22),

            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: finalizarCompra,
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  "Confirmar pedido",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget campoTexto(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF00FF88)),
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFF0A0A0A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget linhaResumo(String titulo, String valor, {bool destaque = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          Text(
            valor,
            style: TextStyle(
              fontSize: destaque ? 20 : 15,
              fontWeight: destaque ? FontWeight.bold : FontWeight.normal,
              color: destaque ? const Color(0xFF00FF88) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}