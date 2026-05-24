import 'package:flutter/material.dart';

class Produto {
  final int id;
  final String nome;
  final String categoria;
  final String descricao;
  final double preco;
  final String imagem;
  final IconData icone;

  Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.descricao,
    required this.preco,
    required this.imagem,
    required this.icone,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    final categoria = json['category'] ?? "Tech";
    final nome = json['title'] ?? "Produto";
    final descricaoOriginal = json['description'] ?? "";

    return Produto(
      id: json['id'],
      nome: nome,
      categoria: categoria,
      descricao: _descricaoEmPortugues(
        nome,
        categoria,
        descricaoOriginal,
      ),
      preco: (json['price'] as num).toDouble(),
      imagem: json['thumbnail'] ?? "",
      icone: _iconePorCategoria(categoria),
    );
  }

  static String _descricaoEmPortugues(
    String nome,
    String categoria,
    String descricaoOriginal,
  ) {
    final c = categoria.toLowerCase();

    if (c.contains('laptops')) {
      return "$nome é um notebook ideal para estudos, trabalho, programação e uso diário, oferecendo bom desempenho e praticidade.";
    }

    if (c.contains('smartphones')) {
      return "$nome é um smartphone moderno, indicado para comunicação, redes sociais, fotos, vídeos e uso no dia a dia.";
    }

    if (c.contains('tablets')) {
      return "$nome é um tablet versátil, ideal para estudos, entretenimento, leitura, vídeos e produtividade.";
    }

    if (c.contains('mobile-accessories') || c.contains('accessories')) {
      return "$nome é um acessório de tecnologia desenvolvido para complementar seus dispositivos e melhorar sua experiência de uso.";
    }

    return "$nome é um produto de informática disponível no catálogo da Omnidex.";
  }

  static IconData _iconePorCategoria(String categoria) {
    final c = categoria.toLowerCase();

    if (c.contains('laptops')) return Icons.laptop;
    if (c.contains('smartphones')) return Icons.phone_android;
    if (c.contains('tablets')) return Icons.tablet;
    if (c.contains('accessories')) return Icons.headphones;

    return Icons.memory;
  }
}