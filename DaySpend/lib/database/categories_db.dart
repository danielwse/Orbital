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

  Future<bool> categoryExist(String categoryName) async {
    final db = await dbProvider.database;
    var result = await db.query("Categories", columns: ['name']).then((list) =>
        list.where((element) => element['name'] == categoryName).toList());
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
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
  Future categoryExist(String categoryName) =>
      categoryDao.categoryExist(categoryName);
}
