import 'dart:async';
import 'package:DaySpend/database/DatabaseHelper.dart';
import 'package:DaySpend/planner/day2index.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:intl/intl.dart';

class TasksDao {
  final dbProvider = DBProvider.db;

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
    final tempTask = Task(id: task.id, index: getIndex(dt), name: task.name, time: DateFormat('Hm').format(dt).toString(), description: task.description, notify: task.notify, dt: dt);
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
}