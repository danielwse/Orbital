import 'dart:async';
import 'package:DaySpend/expenses/database/db_models.dart';
import 'package:DaySpend/expenses/database/DatabaseHelper.dart';

class CategoryDao {
  final dbProvider = DBProvider.db;

  Future<int> newCategory(Categories category) async {
    final db = await dbProvider.database;
    var res = await db.insert("Categories", category.toMap());
    return res;
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

 Future<int> removeAmountFromCategory(double deleteAmount, String category) async {
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
}

class CategoryRepository {
  final categoryDao = CategoryDao();
  Future newCategory(Categories category) => categoryDao.newCategory(category);
  Future getAllCategories() => categoryDao.getAllCategories();
  Future deleteCategory(int id) => categoryDao.deleteCategory(id);
  Future addAmountToCategory(double addAmount, String category) => categoryDao.addAmountToCategory(addAmount, category);
  Future removeAmountFromCategory(double deleteAmount, String category) => categoryDao.removeAmountFromCategory(deleteAmount, category);
  Future renameCategory(String oldName, String newName) => categoryDao.renameCategory(oldName, newName);

}
