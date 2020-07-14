import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:DaySpend/database/db_models.dart';
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
          "amount TEXT,"
          "date TEXT"
          ")");
      await db.execute("CREATE TABLE Categories ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT UNIQUE,"
          "amount TEXT,"
          "budget TEXT"
          ")");
      await db.execute("CREATE TABLE Variables ("
          "type TEXT PRIMARY KEY,"
          "value TEXT "
          ")");
      await db.insert("Variables", {"type": 'MaxSpend', "value": 'Not Set'});
    });
  }

  getMaxSpend() async {
    // Get a reference to the database.
    final Database db = await database;
    maxSpend = await db
        .rawQuery('SELECT value FROM Variables')
        .then((value) => value[0]['value']);
  }

  updateMaxSpend(String maximumSpend) async {
    final db = await database;
    maxSpend = maximumSpend;
    var res = await db
        .update("Variables", {"type": "MaxSpend", "value": maximumSpend});
    return res;
  }

  newExpense(
      String description, String category, double amount, String date) async {
    Expense expense = new Expense(
        description: description,
        category: category,
        amount: amount,
        date: date);
    final db = await database;
    var res = await db.insert("Expenses", expense.toMap());
    return res;
  }

  Future<List<Variable>> getAllVariables() async {
    final db = await database;
    var res = await db.query("Variables");
    List<Variable> list =
        res.isNotEmpty ? res.map((c) => Variable.fromMap(c)).toList() : [];
    return list;
  }
  // blockOrUnblock(Expense Expense) async {
  //   final db = await database;
  //   Expense blocked = Expense(
  //       id: Expense.id,
  //       firstName: Expense.firstName,
  //       lastName: Expense.lastName,
  //       blocked: !Expense.blocked);
  //   var res = await db.update("Expense", blocked.toMap(),
  //       where: "id = ?", whereArgs: [Expense.id]);
  //   return res;
  // }

  // updateExpense(Expense newExpense) async {
  //   final db = await database;
  //   var res = await db.update("Expense", newExpense.toMap(),
  //       where: "id = ?", whereArgs: [newExpense.id]);
  //   return res;
  // }

  // getExpense(int id) async {
  //   final db = await database;
  //   var res = await db.query("Expense", where: "id = ?", whereArgs: [id]);
  //   return res.isNotEmpty ? Expense.fromMap(res.first) : null;
  // }

  // Future<List<Expense>> getBlockedExpenses() async {
  //   final db = await database;

  //   print("works");
  //   // var res = await db.rawQuery("SELECT * FROM Expense WHERE blocked=1");
  //   var res = await db.query("Expense", where: "blocked = ? ", whereArgs: [1]);

  //   List<Expense> list =
  //       res.isNotEmpty ? res.map((c) => Expense.fromMap(c)).toList() : [];
  //   return list;
  // }

  // deleteExpense(int id) async {
  //   final db = await database;
  //   return db.delete("Expense", where: "id = ?", whereArgs: [id]);
  // }

  // deleteAll() async {
  //   final db = await database;
  //   db.rawDelete("Delete * from Expense");
  // }
}
