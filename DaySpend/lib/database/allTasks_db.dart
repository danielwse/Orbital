import 'dart:async';
import 'package:DaySpend/database/DatabaseHelper.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:DaySpend/planner/widget_functions.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class TasksDao {
  final dbProvider = DBProvider.db;

  toggleExpired(Task task) {
    return updateExpired(task.id, task.isExpired ? 0 : 1);
  }

  Future<int> updateExpired(int taskId, int value) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Tasks 
    SET isExpired = '$value'
    WHERE id = '$taskId'
    ''');
    return res;
  }

  toggleArchived(Task task) {
    return updateArchived(task.id, task.isArchived ? 0 : 1);
  }

  Future<int> updateArchived(int taskId, int value) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Tasks 
    SET isArchived = '$value'
    WHERE id = '$taskId'
    ''');
    return res;
  }

  toggleNotify(Task task) {
    return updateNotify(task.id, task.notify ? 0 : 1);
  }

  Future<int> updateNotify(int taskId, int value) async {
    print(value == 0  ? "toggle off (notify)" : "toggle on (notify)");
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Tasks 
    SET notify = '$value'
    WHERE id = '$taskId'
    ''');
    return res;
  }

  toggleComplete(Task task) {
    return updateComplete(task.id, task.isComplete ? 0 : 1);
  }

  Future<int> updateComplete(int taskId, int value) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Tasks 
    SET isComplete = '$value'
    WHERE id = '$taskId'
    ''');
    return res;
  }

  toggleOverdue(Task task) {
    return updateOverdue(task.id, task.isOverdue ? 0 : 1);
  }

  Future<int> updateOverdue(int taskId, int value) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Tasks 
    SET isOverdue = '$value'
    WHERE id = '$taskId'
    ''');
    return res;
  }

  Future<int> newTask(Task task) async {
    if (task != null) {
      final db = await dbProvider.database;
      int res = await db.insert("Tasks", task.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      print("added task with id: " +res.toString());
      return res;
    }
    return null;
  }

  Future removeTask(int id) async {
    final db = await dbProvider.database;
    await db.delete("Tasks", where: 'id = ?', whereArgs: [id]).then((value) => print("deleted task"));
  }

  Future<List<Task>> getAllTasks() async {
    final db = await dbProvider.database;
    var res = await db.query("Tasks");
    List<Task> list = res.isNotEmpty ? res.map((c) => Task.fromJson(c)).toList() : [];
    return list;
  }

  void rescheduleOverdue(Task task, DateTime dt, Duration duration) {
    final tempTask = Task(id: task.id, index: getIndex(dt), name: task.name, time: DateFormat('Hm').format(dt).toString(), description: task.description, notify: false, isComplete: false, isOverdue: false, isArchived: false, isExpired: false, dt: dt, length: duration);
    print("deleted task with id "+ task.id.toString());
    removeTask(task.id);
    newTask(tempTask);
    print("rescheduled: "+ tempTask.name + "@ " + switchDays(tempTask.index) + " - " + tempTask.time + " - id: " + tempTask.id.toString());
  }

  //check if got notification before and after this function
  void updateTask(Task task, String index, String name, String time, String description, bool notify, DateTime dt, Duration duration) {
    final tempTask = Task(id: task.id, index: index, name: name, time: time, description: description, notify: notify, isComplete: false, isOverdue: false, isArchived: false, isExpired: false, dt: dt, length: duration);
    print("deleted task with id "+ task.id.toString());
    removeTask(task.id);
    newTask(tempTask);
    print("updated: "+ tempTask.name + "@ " + switchDays(tempTask.index) + " - " + tempTask.time + " - id: " + tempTask.id.toString());
  }

  void removedExpired() async {
    final db = await dbProvider.database;
    var prevDay = await db.query("TimeValues");
    List<DayIndex> list = prevDay.isNotEmpty ? prevDay.map((c) => DayIndex.fromJson(c)).toList() : [];
    String dbDate = list[0].index;
    print("Last updated on: " + dbDate);
    String currDate = DateFormat("yMMMMd").format(DateTime.now());
    String key = "prevDay";
    if (dbDate != currDate) {
      await db.rawUpdate('''
      UPDATE TimeValues
      SET dayIndex = '$currDate'
      WHERE id = '$key'
      ''');
      List<Task> allTasks = await getAllTasks();
      for (Task task in allTasks) {
        DateTime now = DateTime.now();
        if (task.isExpired && task.dt.isBefore(DateTime(now.year, now.month, now.day).subtract(Duration(days: 6)))) {
          removeTask(task.id);
        }
      }
    }
  }
}

class DayIndex {
  String index;
  DayIndex({this.index});

  factory DayIndex.fromJson(Map<String, dynamic> data) => DayIndex(index: data["dayIndex"]);
}

class TasksRepository {
  final tasksDao = TasksDao();
  Future<int> newTask(Task task) => tasksDao.newTask(task);
  Future getAllTasks() => tasksDao.getAllTasks();
  Future removeTask(int id) => tasksDao.removeTask(id);
  rescheduleOverdue(Task task, DateTime dt, Duration duration) => tasksDao.rescheduleOverdue(task, dt, duration);
  toggleNotification(Task task) => tasksDao.toggleNotify(task);
  toggleComplete(Task task) => tasksDao.toggleComplete(task);
  toggleOverdue(Task task) => tasksDao.toggleOverdue(task);
  toggleArchived(Task task) => tasksDao.toggleArchived(task);
  toggleExpired(Task task) => tasksDao.toggleExpired(task);
  removeExpired() => tasksDao.removedExpired();
  updateTask(Task task, String index, String name, String time, String description, bool notify, DateTime dt, Duration duration) => tasksDao.updateTask(task, index, name, time, description, notify, dt, duration);
}