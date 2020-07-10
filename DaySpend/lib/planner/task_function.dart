import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'day2index.dart';
import 'package:flutter/widgets.dart';

class TaskFunction extends ChangeNotifier {

  void addTask(String index, String name, String time, String des, bool notify, DateTime dateTime) {
    final task = Task(index: index, name: name, time: time, description: des, notify: notify, isComplete: false, isOverdue: false, opacity: 1, dt: dateTime);
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    print("deleted task with id "+ task.id.toString());
    _tasks.remove(task);
    notifyListeners();
  }

  List<Task> _tasks = [
  ]; //should fetch from database

  List<Task> get mainTasks {
    return _tasks;
  }


  List<Task> _completedTasks = [
  ]; //should fetch from database

  List<Task> get completedTasks {
    return _completedTasks;
  }

  int tasksLeft() {
    print(_tasks.length);
    return _tasks.length;
  }

  void resetAddTask() {
    tempName = null;
    tempDes = null;
    tempDateTime =  null;
    tempNotify = false;
    madeChanges = false;
    print("reset temp values");
    notifyListeners();
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
    final newTask = Task(id: task.id, index: getIndex(dt), name: task.name, time: DateFormat('Hm').format(dt).toString(), description: task.description, notify: task.notify, dt: dt);
    print("deleted task with id "+ task.id.toString());
    deleteTask(task);
    addTask(newTask.index, newTask.name, newTask.time, newTask.description, newTask.notify, newTask.dt);
    print("rescheduled: "+ newTask.name + "@ " + switchDays(newTask.index) + " - " + newTask.time + " - id: " + task.id.toString());
    notifyListeners();
  }

  void archiveTask(Task task) {
    final completed = Task(id: task.id, index: task.index, name: task.name, time: task.time, description: task.description, isComplete: true, dt: task.dt);
    _completedTasks.add(completed);
    print("archived task with id: " + task.id.toString() + " to completedTaskList");
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

  void setOpacity(Task task) {
    task.toggleAnimate();
    notifyListeners();
  }
}
