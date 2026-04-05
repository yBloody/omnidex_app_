import 'package:flutter/material.dart';

class Produto {
  final int id;
  final String nome;
  final String categoria;
  final String descricao;
  final double preco;
  final IconData icone;

  const Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.descricao,
    required this.preco,
    required this.icone,
  });
}