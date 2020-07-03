import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';

class TaskFunction extends ChangeNotifier {
  List<Task> _tasks = [
    //Task(index: '1', name: 'name', time: '14:00', description: 'des', notify: false)
  ]; //should fetch from database

  List<Task> get tasks {
    return _tasks;
  }

  List<Task> _completedTasks = [
  ]; //should fetch from database

  List<Task> get completedTasks {
    return _completedTasks;
  }

  void addTask(String index, String name, String time, String des, bool notify) {
    final task = Task(index: index, name: name, time: time, description: des, notify: notify);
    _tasks.add(task);
    notifyListeners();
  }

  void archiveTask(Task task) {
    final completed = Task(index: task.index, name: task.name, time: task.time, description: task.description, isComplete: true);
    _completedTasks.add(completed);
    notifyListeners();
  }

  void updateNotify(Task task) {
    task.toggleNotify();
    notifyListeners();
  }

  void updateComplete(Task task) {
    task.toggleComplete();
    notifyListeners();
  }

  void updateOverdue(Task task) {
    task.toggleOverdue();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void setOpacity(Task task) {
    task.toggleAnimate();
    notifyListeners();
  }
}