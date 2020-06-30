import 'dart:collection';
import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';

class TaskFunction extends ChangeNotifier{
  List<Task> _tasks = [
    Task('1', 'Run', '17:30', 'overdue','Lorem ipsum dolor sit amet consectetur adipiscing elit. Duis dapibus rutrum facilisis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.'),
    Task('1', 'Eat', '20:00', 'notify','Lorem ipsum dolor sit amet consectetur adipiscing elit. Duis dapibus rutrum facilisis.'),
    Task('1', 'Study', '16:00', 'completed', 'Lorem ipsum dolor sit amet consectetur adipiscing elit. Duis dapibus rutrum facilisis.'),
    Task('2', 'Study', '16:00', 'completed', 'Lorem ipsum dolor sit amet consectetur adipiscing elit. Duis dapibus rutrum facilisis.'),
    Task('2', 'Eat', '17:00', '','Lorem ipsum dolor sit amet consectetur adipiscing elit. Duis dapibus rutrum facilisis.'),
    Task('3', 'Study', '16:00', '', 'Duis dapibus rutrum facilisis.'),
    Task('4', 'Study', '16:00', 'completed','Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.'),
    Task('4', 'Run', '20:00', '', 'Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.'),
    Task('5', 'Study', '16:00', '','Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.'),
    Task('5', 'Study', '20:00', 'notify','Lorem ipsum dolor sit amet consectetur adipiscing elit. Duis dapibus rutrum facilisis.'),
    Task('5', 'Play', '22:00', '','Lorem ipsum dolor sit amet consectetur adipiscing elit. Duis dapibus rutrum facilisis.'),
    Task('6', 'Study', '16:00', 'notify','Lorem ipsum dolor sit amet consectetur adipiscing elit. Duis dapibus rutrum facilisis.'),
    Task('7', 'Study', '16:00', '','Duis dapibus rutrum facilisis.'),
    Task('2', 'Study', '11:00', 'overdue','Duis dapibus rutrum facilisis.')
  ]; //should import from database

//  UnmodifiableListView<Task> get tasks {
//    return UnmodifiableListView(_tasks);
  List<Task> get tasks {
    return _tasks;
  }

  void addTask(String index, String name, String time, String status, String des) {
    final task = Task(index,name,time,status,des);
    _tasks.add(task);
    notifyListeners();
  }
}