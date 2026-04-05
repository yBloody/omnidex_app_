import 'package:flutter/material.dart';
import '../data/produtos_data.dart';
import '../controllers/carrinho_controller.dart';
import 'login_page.dart';
import 'produto_detalhe_page.dart';
import 'carrinho_page.dart';
import 'suporte_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String busca = '';

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = produtos.where((produto) {
      return produto.nome.toLowerCase().contains(busca.toLowerCase()) ||
          produto.categoria.toLowerCase().contains(busca.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo OmniDex'),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SuportePage()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarrinhoPage()),
                  );
                  setState(() {});
                },
              ),
              if (CarrinhoController.itens.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${CarrinhoController.itens.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF111827),
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.computer, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'OmniDex',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Menu principal',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Catálogo'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Carrinho'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarrinhoPage()),
                ).then((_) => setState(() {}));
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Suporte'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SuportePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Pesquisar produto...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  busca = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: produtosFiltrados.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum produto encontrado.',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: produtosFiltrados.length,
                      itemBuilder: (context, index) {
                        final produto = produtosFiltrados[index];
                        return Card(
                          color: const Color(0xFF1F2937),
                          margin: const EdgeInsets.only(bottom: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFF0A84FF),
                              child: Icon(produto.icone, color: Colors.white),
                            ),
                            title: Text(
                              produto.nome,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${produto.categoria}\nR\$ ${produto.preco.toStringAsFixed(2)}',
                            ),
                            isThreeLine: true,
                            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProdutoDetalhePage(produto: produto),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}