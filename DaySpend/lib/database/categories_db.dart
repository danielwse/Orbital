import 'dart:async';
import 'package:DaySpend/database/db_models.dart';
import 'package:DaySpend/database/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDao {
  final dbProvider = DBProvider.db;

  Future<int> newCategory(Categories category) async {
    if (category != null) {
      final db = await dbProvider.database;
      var res = await db.insert("Categories", category.toMap());
      return res;
    }
    return null;
  }

  Future<int> deleteCategory(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete("Categories", where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<int> addAmountToCategory(double addAmount, String category) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Categories 
    SET amount = amount + $addAmount
    WHERE name = '$category'
    ''');
    return res;
  }

  static DateTime convertStringtoDatetime(String date) {
    String result =
        date.substring(0, 4) + date.substring(5, 7) + date.substring(8);
    return DateTime.parse(result);
  }

  calculateCategoryAmount(String category) async {
    double totalAmt = 0;
    final db = await dbProvider.database;
    var res =
        await db.query("Expenses", columns: ['category', 'amount', 'date']);
    for (final expense in res) {
      if (expense['category'].toLowerCase() == category.toLowerCase() &&
          convertStringtoDatetime(expense['date']).isAfter(
              DateTime(DateTime.now().year, DateTime.now().month, 1))) {
        totalAmt += expense['amount'];
      }
    }
    var result = await db.rawUpdate('''
    UPDATE Categories
    SET amount = $totalAmt
    WHERE name = '${category[0].toUpperCase() + category.substring(1)}'
    ''');

    return result;
  }

  Future<int> removeAmountFromCategory(
      double deleteAmount, String category) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Categories
    SET amount = amount - $deleteAmount
    WHERE name = '$category'
    ''');
    return res;
  }

  Future<int> renameCategory(String oldName, String newName) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Categories
    SET name = '$newName'
    WHERE name = '$oldName'
    ''');
    return res;
  }

  Future<List<Categories>> getAllCategories() async {
    final db = await dbProvider.database;
    var res = await db.query("Categories");
    List<Categories> list =
        res.isNotEmpty ? res.map((c) => Categories.fromMap(c)).toList() : [];
    return list;
  }

  Future<double> getTotalBudgets() async {
    double total = 0;
    final db = await dbProvider.database;
    var res = await db.query("Categories", columns: ['budgetPercentage']);
    for (final budget in res) {
      if (budget['budgetPercentage'] != "Not Set") {
        total += double.parse(budget['budgetPercentage']);
      }
    }
    return total;
  }

  getCategoryColour(String categoryName) async {
    final db = await dbProvider.database;
    var res = await db.query("Categories", columns: ['name', 'color']).then(
        (list) =>
            list.where((element) => element['name'] == categoryName).toList());

    return res.isEmpty ? null : res[0]['color'];
  }

  Future<int> categoriesCount() async {
    final db = await dbProvider.database;
    var res = await db.rawQuery('''SELECT COUNT (*) from 
    Categories''');
    int count = Sqflite.firstIntValue(res);
    return count;
  }

  Future<int> changeBudget(String newBudget, int categoryID) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Categories
    SET budgetPercentage = '$newBudget'
    WHERE id = '$categoryID'
    ''');
    return res;
  }

  Future<List<String>> categoryNameList() async {
    List<String> list = [];
    final db = await dbProvider.database;
    await db.query("Categories", columns: ['name']).then(
        (element) => element.forEach((element) {
              list.add(element['name'].toLowerCase());
            }));
    return list;
  }
}

class CategoryRepository {
  final categoryDao = CategoryDao();
  Future newCategory(Categories category) => categoryDao.newCategory(category);
  Future getAllCategories() => categoryDao.getAllCategories();
  Future deleteCategory(int id) => categoryDao.deleteCategory(id);
  Future addAmountToCategory(double addAmount, String category) =>
      categoryDao.addAmountToCategory(addAmount, category);
  Future removeAmountFromCategory(double deleteAmount, String category) =>
      categoryDao.removeAmountFromCategory(deleteAmount, category);
  Future renameCategory(String oldName, String newName) =>
      categoryDao.renameCategory(oldName, newName);
  Future categoriesCount() => categoryDao.categoriesCount();
  Future getTotalBudgets() => categoryDao.getTotalBudgets();
  Future changeBudget(String newBudget, int categoryID) =>
      categoryDao.changeBudget(newBudget, categoryID);
  Future getCategoryColor(String categoryName) =>
      categoryDao.getCategoryColour(categoryName);
  Future categoryNameList() => categoryDao.categoryNameList();
  Future calculateCategoryAmount(String category) =>
      categoryDao.calculateCategoryAmount(category);
}
