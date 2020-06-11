//Initializes Database 

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static String maxSpend;

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Expense.db");
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Expenses ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "description TEXT,"
          "category TEXT,"
          "amount DOUBLE,"
          "date TEXT"
          ")");
      await db.execute("CREATE TABLE Categories ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT UNIQUE,"
          "amount DOUBLE,"
          "budget DOUBLE"
          ")");
      await db.execute("CREATE TABLE Variables ("
          "type TEXT PRIMARY KEY,"
          "value TEXT "
          ")");
      await db.insert("Variables", {"type": 'MaxSpend', "value": 'Not Set'});
      await db.insert("Categories", {"name": "Others", "amount": 0, "budget": 0});
    });
  }
}
