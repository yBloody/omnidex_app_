import '../data/database_helper.dart';
import '../models/produto.dart';

class CarrinhoController {
  static Future<void> adicionar(Produto p) async {
    await DatabaseHelper.addProduto({
      "id": p.id,
      "nome": p.nome,
      "categoria": p.categoria,
      "descricao": p.descricao,
      "preco": p.preco,
      "imagem": p.imagem,
    });
  }
}