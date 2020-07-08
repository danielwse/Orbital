import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'day2index.dart';

class TaskFunction extends ChangeNotifier {
  List<Task> _tasks = [
    //Task(index: '1', name: 'name', time: '14:00', description: 'des', notify: false, dt: DateTime.now())
  ]; //should fetch from database

  List<Task> get tasks {
    return _tasks;
  }

  List<Task> _completedTasks = [
  ]; //should fetch from database

  List<Task> get completedTasks {
    return _completedTasks;
  }

  void resetAddTask() {
    tempName = null;
    tempDes = null;
    tempDateTime =  null;
    tempNotify = false;
    madeChanges = false;
    print("reset temp values");
  }

  bool tempNotify = false;

  bool madeChanges = false;

  void changeNotify(bool input) {
    tempNotify = input;
    notifyListeners();
  }

  bool storedNotify() {
    return tempNotify;
  }

  void changesMade(bool input) {
    madeChanges = input;
    notifyListeners();
  }

  bool areChangesMade() {
    return madeChanges;
  }

  String tempName;
  String tempDes;

  void changeName (String input) {
    tempName = input;
    notifyListeners();
  }

  void changeDes (String input) {
    tempDes = input;
    notifyListeners();
  }

  String storedName() {
    return tempName;
  }

  String storedDes() {
    return tempDes;
  }

  DateTime tempDateTime;

  DateTime storedDateTime() {
    return tempDateTime;
  }

  void changeDateTime (DateTime dt) {
    tempDateTime = dt;
    notifyListeners();
  }

  void rescheduleOverdue(Task task, DateTime dt) {
    final newTask = Task(index: getIndex(dt), name: task.name, time: DateFormat('Hm').format(dt).toString(), description: task.description, notify: task.notify, dt: dt);
    _tasks.remove(task);
    _tasks.add(newTask);
    print("rescheduled: "+ newTask.name + "@ " + switchDays(newTask.index) + " - " + newTask.time);
    notifyListeners();
  }

  void addTask(String index, String name, String time, String des, bool notify, DateTime dateTime) {
    final task = Task(index: index, name: name, time: time, description: des, notify: notify, dt: dateTime);
    _tasks.add(task);
    notifyListeners();
  }

  void archiveTask(Task task) {
    final completed = Task(index: task.index, name: task.name, time: task.time, description: task.description, isComplete: true, dt: task.dt);
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