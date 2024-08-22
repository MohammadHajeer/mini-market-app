import 'package:mini_market_app/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  final String _productsTableName = "products";
  final String _productsIdColumn = "id";
  final String _productsNameColumn = "name";
  final String _productsPriceColumn = "price";
  final String _productsBarCodeColumn = "bar_code";

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "my_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
    );
    return database;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_productsTableName (
        $_productsIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $_productsNameColumn TEXT NOT NULL,
        $_productsPriceColumn REAL NOT NULL,
        $_productsBarCodeColumn TEXT NOT NULL
      )
      ''');
  }

  void addProduct(product) async {
    final db = await database;
    await db.insert('products', product);
  }

  Future<int> insertProduct(String name, double price, String barCode) async {
    final db = await database;
    return await db.insert('products', {
      _productsNameColumn: name,
      _productsPriceColumn: price,
      _productsBarCodeColumn: barCode
    });
  }

  Future<List<ProductModel>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query(_productsTableName);

    List<ProductModel> products = data
        .map((e) => ProductModel(
              id: e["id"],
              name: e["name"],
              price: e["price"],
              barCode: e["bar_code"],
            ))
        .toList();

    return products;
  }
  Future<ProductModel?> getProduct(String barCode) async {
    final db = await database;

    final List<Map<String, dynamic>> data = await db.query(
      _productsTableName,
      where: 'bar_code = ?',
      whereArgs: [barCode],
    );

    if (data.isNotEmpty) {
      return ProductModel(
        id: data[0]["id"],
        name: data[0]["name"],
        price: data[0]["price"],
        barCode: data[0]["bar_code"],
      );
    } else {
      return null;
    }
  }


  Future<int> updateProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
