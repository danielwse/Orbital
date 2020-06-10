import 'dart:async';
import 'package:DaySpend/expenses/database/DatabaseHelper.dart';
import 'package:DaySpend/expenses/db_models.dart';

class ExpensesDao {
  final dbProvider = DBProvider.db;

 newExpense(
      String description, String category, String amount, String date) async {
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
}

class ExpensesRepository {
  final expensesDao = ExpensesDao();
  Future getAllExpenses() => expensesDao.getAllExpenses();
  Future newExpense(String description, String category, String amount, String date) => 
  expensesDao.newExpense(description, category, amount, date);
}
