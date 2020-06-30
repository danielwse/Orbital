import 'dart:async';
import 'package:DaySpend/expenses/database/DatabaseHelper.dart';
import 'package:DaySpend/expenses/database/db_models.dart';

class VariablesDao {
  final dbProvider = DBProvider.db;
  static String maxSpend;

  Future<dynamic> getMaxSpend() async {
    // Get a reference to the database.
    final db = await dbProvider.database;
    maxSpend = await db
        .rawQuery('SELECT value FROM Variables')
        .then((value) => value[0]['value']);
        return maxSpend;
  }

  Future<int> updateMaxSpend(String maximumSpend) async {
    if (maximumSpend != null) {
    final db = await dbProvider.database;
    maxSpend = maximumSpend;
    var res = await db
        .update("Variables", {"type": "MaxSpend", "value": maximumSpend});
    return res;
    }
    return null;
  }

  Future<List<Variable>> getAllVariables() async {
    final db = await dbProvider.database;
    var res = await db.query("Variables");
    List<Variable> list =
        res.isNotEmpty ? res.map((c) => Variable.fromMap(c)).toList() : [];
    return list;
  }
}

class VariablesRepository {
  final variablesDao = VariablesDao();
  Future getMaxSpend() => variablesDao.getMaxSpend();
  Future updateMaxSpend(String maximumSpend) => variablesDao.updateMaxSpend(maximumSpend);
  Future getAllVariables() => variablesDao.getAllVariables();
}
