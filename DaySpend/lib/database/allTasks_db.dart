import 'dart:async';
import 'package:DaySpend/database/DatabaseHelper.dart';
import 'package:DaySpend/planner/day2index.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:intl/intl.dart';

class TasksDao {
  final dbProvider = DBProvider.db;

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
      var res = await db.insert("Tasks", task.toJson());
      return res;
    }
    return null;
  }

  Future<int> removeTask(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete("Tasks", where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<Task>> getAllTasks() async {
    final db = await dbProvider.database;
    var res = await db.query("Tasks");
    List<Task> list = res.isNotEmpty ? res.map((c) => Task.fromJson(c)).toList() : [];
    return list;
  }

  void rescheduleOverdue(Task task, DateTime dt) {
    final tempTask = Task(id: task.id, index: getIndex(dt), name: task.name, time: DateFormat('Hm').format(dt).toString(), description: task.description, notify: task.notify, isComplete: task.isComplete, isOverdue: false, isArchived: task.isArchived, dt: dt);
    print("deleted task with id "+ task.id.toString());
    removeTask(task.id);
    newTask(tempTask);
    print("rescheduled: "+ tempTask.name + "@ " + switchDays(tempTask.index) + " - " + tempTask.time + " - id: " + tempTask.id.toString());
  }
}

class TasksRepository {
  final tasksDao = TasksDao();
  Future newTask(Task task) => tasksDao.newTask(task);
  Future getAllTasks() => tasksDao.getAllTasks();
  Future removeTask(int id) => tasksDao.removeTask(id);
  rescheduleOverdue(Task task, DateTime dt) => tasksDao.rescheduleOverdue(task, dt);
  toggleNotification(Task task) => tasksDao.toggleNotify(task);
  toggleComplete(Task task) => tasksDao.toggleComplete(task);
  toggleOverdue(Task task) => tasksDao.toggleOverdue(task);
  toggleArchived(Task task) => tasksDao.toggleArchived(task);
}