//import 'dart:ffi';
import 'dart:io';
//import 'package:intl/intl.dart';
import 'package:bachelor_project/model/Recipe.dart';

import '../database/database_connection.dart';
import '../model/Product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseRepository {
  static const _name = "products.db";
  static const _version = 1;
  static const _productsTable = "product";
  static const _recipeTable = "recipe";

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
    await db.execute('''CREATE TABLE $_productsTable
        (id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        brand TEXT NOT NULL,
        quantity REAL,
        unit TEXT NOT NULL,
        bestBeforeDate TEXT NOT NULL)''');

    await db.execute('''CREATE TABLE $_recipeTable
        (id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        instructions TEXT NOT NULL)''');
  }

  Future<List<Product>> getProducts() async {
    Database db = await Instance.database;

    var products = await db.query(_productsTable);

    List<Product> productList = products.isNotEmpty
        ? products.map((prod) => Product.fromMap(prod)).toList()
        : [];

    return productList;
  }

  Future<List<Recipe>> getRecipes() async {
    Database db = await Instance.database;

    var recipes = await db.query(_recipeTable);

    List<Recipe> recipeList = recipes.isNotEmpty
        ? recipes.map((recipe) => Recipe.fromMap(recipe)).toList()
        : [];

    return recipeList;
  }

  Future<String> getDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<Product>> getProductsFromCategory(String category) async{
    Database db = await Instance.database;
    var products = await db.query(_productsTable, where: 'category = ?', whereArgs: [category]);

    List<Product> productList = products.isNotEmpty
        ? products.map((prod) => Product.fromMap(prod)).toList()
        : [];

    return productList;
  }

  Future<List<Recipe>> getRecipesFromCategory(String category) async {
    Database db = await Instance.database;

    var recipes = await db.query(_recipeTable, where: 'category = ?', whereArgs: [category]);

    List<Recipe> recipeList = recipes.isNotEmpty
        ? recipes.map((recipe) => Recipe.fromMap(recipe)).toList()
        : [];

    return recipeList;
  }

  Future<int> addProduct(Product product) async {
    Database db = await Instance.database;
    return await db.insert(_productsTable, product.toMap());
  }

  Future<int> addRecipe(Recipe recipe) async {
    Database db = await Instance.database;
    return await db.insert(_recipeTable, recipe.toMap());
  }

  Future<int> deleteProduct(int id) async {
    Database db = await Instance.database;
    return await db.delete(_productsTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteRecipe(int id) async {
    Database db = await Instance.database;
    return await db.delete(_recipeTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> editProduct(Product product) async {
    Database db = await Instance.database;
    return await db.update(_productsTable, product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  Future<int> editRecipe(Recipe recipe) async {
    Database db = await Instance.database;
    return await db.update(_recipeTable, recipe.toMap(),
        where: 'id = ?', whereArgs: [recipe.id]);
  }

  Future<List<Product>> getProductFromRecipe(String name) async {
    Database db = await Instance.database;

    var products = await db.query(_productsTable, where: 'name LIKE ?', whereArgs: ['%$name%'], orderBy: 'bestBeforeDate');

    List<Product> productList = products.isNotEmpty
        ? products.map((prod) => Product.fromMap(prod)).toList()
        : [];

    return productList;
  }
}
