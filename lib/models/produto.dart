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

    return Produto(
      id: json['id'],
      nome: json['title'],
      categoria: categoria,
      descricao: json['description'],
      preco: (json['price'] as num).toDouble(),
      imagem: json['thumbnail'],
      icone: _iconePorCategoria(categoria),
    );
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