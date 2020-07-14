import 'dart:async';
import 'package:DaySpend/database/DatabaseHelper.dart';
import 'package:DaySpend/database/db_models.dart';

class ExpensesDao {
  final dbProvider = DBProvider.db;

  newExpense(
      String description, String category, double amount, String date) async {
    Expense expense = new Expense(
        description: description,
        category: category,
        amount: amount,
        date: date);
    final db = await dbProvider.database;
    var res = await db.insert("Expenses", expense.toMap());
    return res;
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await dbProvider.database;
    var res = await db.query("Expenses");
    List<Expense> list =
        res.isNotEmpty ? res.map((c) => Expense.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> deleteExpense(
      int id, double deleteAmount, String category) async {
    final db = await dbProvider.database;
    var result = await db.delete("Expenses", where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<int> changeExpenseCategory(String category, int id) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Expenses 
    SET category = '$category'
    WHERE id = $id
    ''');
    return res;
  }

  Future<int> changeDescription(String newDescription, int id) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Expenses 
    SET description = '$newDescription'
    WHERE id = $id
    ''');
    return res;
  }

  Future<int> changeAmount(double newAmount, int id) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Expenses 
    SET amount = '$newAmount'
    WHERE id = $id
    ''');
    return res;
  }

  Future<int> changeDate(String newDate, int id) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Expenses 
    SET date = '$newDate'
    WHERE id = $id
    ''');
    return res;
  }

  Future getExpensesByCategory(String category) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT * FROM Expenses WHERE category = '$category'
    ''');
    List<Expense> list = List.generate(maps.length, (i) {
      return Expense(
          id: maps[i]['id'],
          category: maps[i]['category'],
          description: maps[i]['description'],
          amount: maps[i]['amount'],
          date: maps[i]['date']);
    });
    return list;
  }
}

class ExpensesRepository {
  final expensesDao = ExpensesDao();
  Future getAllExpenses() => expensesDao.getAllExpenses();
  Future newExpense(
          String description, String category, double amount, String date) =>
      expensesDao.newExpense(description, category, amount, date);
  Future deleteExpense(int id, double amount, String category) =>
      expensesDao.deleteExpense(id, amount, category);
  Future getExpensesByCategory(String category) =>
      expensesDao.getExpensesByCategory(category);
  Future changeExpenseCategory(String category, int id) =>
      expensesDao.changeExpenseCategory(category, id);
  Future changeDescription(String newDescription, int id) =>
      expensesDao.changeDescription(newDescription, id);
  Future changeAmount(double newAmount, int id) =>
      expensesDao.changeAmount(newAmount, id);
  Future changeDate(String newDate, int id) =>
      expensesDao.changeDate(newDate, id);
}
