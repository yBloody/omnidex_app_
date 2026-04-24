import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ApiService {
  static Future<List<Produto>> getProdutos() async {
    final urls = [
      'https://dummyjson.com/products/category/laptops',
      'https://dummyjson.com/products/category/smartphones',
      'https://dummyjson.com/products/category/tablets',
      'https://dummyjson.com/products/category/mobile-accessories',
    ];

    List<Produto> todos = [];

    for (var url in urls) {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final lista = data['products'] as List;

        todos.addAll(lista.map((e) => Produto.fromJson(e)));
      }
    }

    return todos;
  }
}