import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/produto.dart';
import '../services/api_service.dart';
import 'carrinho_page.dart';
import 'produto_detalhe_page.dart';
import 'suporte_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formato = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  late Future<List<Produto>> futureProdutos;

  @override
  void initState() {
    super.initState();
    futureProdutos = ApiService.getProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OmniDex"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarrinhoPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SuportePage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF001A0F)],
          ),
        ),
        child: FutureBuilder<List<Produto>>(
          future: futureProdutos,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00FF88),
                ),
              );
            }

            final produtos = snapshot.data!;

            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (_, i) {
                final p = produtos[i];

                return Card(
                  color: const Color(0xFF0A0A0A),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        p.imagem,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: const Color(0xFF00FF88),
                            child: Icon(
                              p.icone,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      p.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      formato.format(p.preco),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProdutoDetalhePage(produto: p),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}