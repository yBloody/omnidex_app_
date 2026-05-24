import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/database_helper.dart';
import 'finalizar_compra_page.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  final formato = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  List<Map<String, dynamic>> itens = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await DatabaseHelper.getCarrinho();

    setState(() {
      itens = dados;
    });
  }

  double get total {
    double soma = 0;

    for (final item in itens) {
      soma += (item['preco'] as num).toDouble() * (item['quantidade'] as int);
    }

    return soma;
  }

  Future<void> aumentar(int id) async {
    await DatabaseHelper.aumentarQuantidade(id);
    await carregar();
  }

  Future<void> diminuir(int id) async {
    await DatabaseHelper.diminuirQuantidade(id);
    await carregar();
  }

  Future<void> remover(int id) async {
    await DatabaseHelper.removerProduto(id);
    await carregar();
  }

  Future<void> limpar() async {
    await DatabaseHelper.limparCarrinho();
    await carregar();
  }

  void irParaFinalizarCompra() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FinalizarCompraPage(
          itens: itens,
          total: total,
        ),
      ),
    ).then((_) => carregar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        actions: [
          if (itens.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: limpar,
            ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF001A0F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: itens.isEmpty
            ? const Center(
                child: Text(
                  "Carrinho vazio",
                  style: TextStyle(fontSize: 22, color: Colors.white70),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: itens.length,
                      itemBuilder: (_, i) {
                        final p = itens[i];
                        final qtd = p['quantidade'] as int;
                        final preco = (p['preco'] as num).toDouble();

                        return Card(
                          color: const Color(0xFF0A0A0A),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    p['imagem'],
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) {
                                      return Container(
                                        width: 55,
                                        height: 55,
                                        color: const Color(0xFF00FF88),
                                        child: const Icon(
                                          Icons.memory,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p['nome'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formato.format(preco),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Color(0xFF00FF88),
                                      ),
                                      onPressed: () => diminuir(p['id']),
                                    ),
                                    Text(
                                      "$qtd",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: Color(0xFF00FF88),
                                      ),
                                      onPressed: () => aumentar(p['id']),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => remover(p['id']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0A0A0A),
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFF00FF88),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formato.format(total),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00FF88),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: irParaFinalizarCompra,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00FF88),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Finalizar compra",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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