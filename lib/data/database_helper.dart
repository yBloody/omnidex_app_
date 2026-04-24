import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> getDb() async {
    if (_db != null) return _db!;

    _db = await openDatabase(
      join(await getDatabasesPath(), 'omnidex.db'),
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE carrinho(
            id INTEGER PRIMARY KEY,
            nome TEXT,
            categoria TEXT,
            descricao TEXT,
            preco REAL,
            imagem TEXT,
            quantidade INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS carrinho');
        await db.execute('''
          CREATE TABLE carrinho(
            id INTEGER PRIMARY KEY,
            nome TEXT,
            categoria TEXT,
            descricao TEXT,
            preco REAL,
            imagem TEXT,
            quantidade INTEGER
          )
        ''');
      },
    );

    return _db!;
  }

  static Future<void> addProduto(Map<String, dynamic> p) async {
    final db = await getDb();

    final existente = await db.query(
      'carrinho',
      where: 'id = ?',
      whereArgs: [p['id']],
    );

    if (existente.isNotEmpty) {
      final qtdAtual = existente.first['quantidade'] as int;

      await db.update(
        'carrinho',
        {'quantidade': qtdAtual + 1},
        where: 'id = ?',
        whereArgs: [p['id']],
      );
    } else {
      await db.insert('carrinho', {
        ...p,
        'quantidade': 1,
      });
    }
  }

  static Future<List<Map<String, dynamic>>> getCarrinho() async {
    final db = await getDb();
    return db.query('carrinho');
  }

  static Future<void> aumentarQuantidade(int id) async {
    final db = await getDb();

    final item = await db.query(
      'carrinho',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (item.isNotEmpty) {
      final qtd = item.first['quantidade'] as int;

      await db.update(
        'carrinho',
        {'quantidade': qtd + 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  static Future<void> diminuirQuantidade(int id) async {
    final db = await getDb();

    final item = await db.query(
      'carrinho',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (item.isNotEmpty) {
      final qtd = item.first['quantidade'] as int;

      if (qtd > 1) {
        await db.update(
          'carrinho',
          {'quantidade': qtd - 1},
          where: 'id = ?',
          whereArgs: [id],
        );
      } else {
        await removerProduto(id);
      }
    }
  }

  static Future<void> removerProduto(int id) async {
    final db = await getDb();
    await db.delete(
      'carrinho',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> limparCarrinho() async {
    final db = await getDb();
    await db.delete('carrinho');
  }
}