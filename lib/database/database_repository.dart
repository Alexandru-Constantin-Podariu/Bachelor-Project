//import 'dart:ffi';
import 'dart:io';
//import 'package:intl/intl.dart';
import '../database/database_connection.dart';
import '../model/Product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseRepository {
  static const _name = "products.db";
  static const _version = 1;
  static const _table = "product";

  DatabaseRepository._();

  static final DatabaseRepository Instance = DatabaseRepository._();
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _name);
    print('db path: ' + path);

    return await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $_table
        (id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        brand TEXT NOT NULL,
        quantity REAL,
        unit TEXT NOT NULL,
        bestBeforeDate TEXT NOT NULL)''');
  }

  Future<List<Product>> getProducts() async {
    Database db = await Instance.database;

    var products = await db.query(_table);

    List<Product> productList = products.isNotEmpty
        ? products.map((prod) => Product.fromMap(prod)).toList()
        : [];

    return productList;
  }

  Future<String> getDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<Product>> getProductsFromCategory(String category) async{
    Database db = await Instance.database;
    var products = await db.query(_table, where: 'category = ?', whereArgs: [category]);

    List<Product> productList = products.isNotEmpty
        ? products.map((prod) => Product.fromMap(prod)).toList()
        : [];

    return productList;
  }

  Future<int> add(Product product) async {
    Database db = await Instance.database;
    return await db.insert(_table, product.toMap());
  }

  Future<int> delete(int id) async {
    Database db = await Instance.database;
    return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> edit(Product product) async {
    Database db = await Instance.database;
    return await db.update(_table, product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }
}
