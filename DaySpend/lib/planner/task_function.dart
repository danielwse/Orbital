import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';

class TaskFunction extends ChangeNotifier{
  List<Task> _tasks = [
  ]; //should import from database

//  UnmodifiableListView<Task> get tasks {
//    return UnmodifiableListView(_tasks);
  List<Task> get tasks {
    return _tasks;
  }

  void addTask(String index, String name, String time, String des, bool notify, bool complete, bool overdue) {
    final task = Task(index: index, name: name, time: time, description: des, notify: notify, isComplete: complete, isOverdue: overdue);
    _tasks.add(task);
    notifyListeners();
  }

  void updateStatus(Task task) {
    task.toggleNotify();
    notifyListeners();
  }
}