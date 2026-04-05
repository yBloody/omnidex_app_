import 'package:flutter/material.dart';
import '../models/produto.dart';

final List<Produto> produtos = [
  const Produto(
    id: 1,
    nome: 'Mouse Gamer RGB',
    categoria: 'Periféricos',
    descricao: 'Mouse com sensor de alta precisão, iluminação RGB e design ergonômico.',
    preco: 129.90,
    icone: Icons.mouse,
  ),
  const Produto(
    id: 2,
    nome: 'Teclado Mecânico',
    categoria: 'Periféricos',
    descricao: 'Teclado mecânico com switches táteis, LED e estrutura reforçada.',
    preco: 249.90,
    icone: Icons.keyboard,
  ),
  const Produto(
    id: 3,
    nome: 'Headset Pro X',
    categoria: 'Áudio',
    descricao: 'Headset com som imersivo, microfone com redução de ruído e conforto premium.',
    preco: 199.90,
    icone: Icons.headphones,
  ),
  const Produto(
    id: 4,
    nome: 'Monitor 24" 144Hz',
    categoria: 'Monitores',
    descricao: 'Monitor gamer Full HD com taxa de atualização de 144Hz.',
    preco: 899.90,
    icone: Icons.monitor,
  ),
  const Produto(
    id: 5,
    nome: 'SSD NVMe 1TB',
    categoria: 'Armazenamento',
    descricao: 'SSD ultrarrápido para melhorar o desempenho do sistema.',
    preco: 379.90,
    icone: Icons.storage,
  ),
  const Produto(
    id: 6,
    nome: 'Placa de Vídeo RTX',
    categoria: 'Hardware',
    descricao: 'Placa de vídeo de alto desempenho para jogos e produtividade.',
    preco: 2499.90,
    icone: Icons.memory,
  ),
];