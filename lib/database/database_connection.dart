import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection{
  setDatabase() async{
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_products');
    var database = await openDatabase(path, version: 1, onCreate: createDatabase);
    return database;
  }
  
  createDatabase(Database database, int version) async{
    await database.execute(
      "CREATE TABLE product"
        "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name TEXT NOT NULL,"
        "category TEXT NOT NULL,"
        "brand TEXT NOT NULL,"
        "quantity REAL,"
        "unit TEXT NOT NULL,"
        "bestBeforeDate TEXT NOT NULL)"
    );
  }
}