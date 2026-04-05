import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../controllers/carrinho_controller.dart';

class ProdutoDetalhePage extends StatelessWidget {
  final Produto produto;

  const ProdutoDetalhePage({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                produto.icone,
                size: 100,
                color: const Color(0xFF0A84FF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              produto.nome,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              produto.categoria,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Text(
              produto.descricao,
              style: const TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'R\$ ${produto.preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00E676),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  CarrinhoController.adicionar(produto);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${produto.nome} adicionado ao carrinho')),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  'Adicionar ao Carrinho',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A84FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}