import '../models/produto.dart';

class CarrinhoController {
  static final List<Produto> itens = [];

  static void adicionar(Produto produto) {
    itens.add(produto);
  }

  static void remover(Produto produto) {
    itens.remove(produto);
  }

  static double get total {
    double soma = 0;
    for (var item in itens) {
      soma += item.preco;
    }
    return soma;
  }
}