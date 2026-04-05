import 'package:flutter/material.dart';
import '../data/produtos_data.dart';
import 'produto_detalhe_page.dart';
import 'carrinho_page.dart';
import 'suporte_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OmniDex'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CarrinhoPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SuportePage()));
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
        child: ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final p = produtos[index];

            return Card(
              color: const Color(0xFF0A0A0A),
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF00FF88),
                  child: Icon(p.icone, color: Colors.black),
                ),
                title: Text(p.nome),
                subtitle: Text("R\$ ${p.preco}"),
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
        ),
      ),
    );
  }
}