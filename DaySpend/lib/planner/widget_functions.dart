import 'package:DaySpend/planner/day2index.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class PlannerWidgetFunctions extends ChangeNotifier {

  //might move this to db, but if working, leave it
  void setOpacity(Task task) {
    task.toggleAnimate();
    notifyListeners();
  }

  List<Task> getTodayTasks(List<Task> input) {
    List<Task> output = [];
    for (Task task in input) {
      if (!task.isExpired && !task.isArchived && task.index == getIndex(DateTime.now())) {
        output.add(task);
      } else {
        continue;
      }
    }
    return output;
  }

  List<Task> getRecent(List<Task> input) {
    List<Task> output = [];
    for (Task task in input) {
      if (!task.isExpired && !task.isArchived) {
        output.add(task);
      } else {
        continue;
      }
    }
    return output;
  }

  List<Task> getArchived(List<Task> input) {
    List<Task> output = [];
    for (Task task in input) {
      if (task.isArchived) {
        output.add(task);
      } else {
        continue;
      }
    }
    return output;
  }

  List<Task> getOverdue(List<Task> input) {
    List<Task> output = [];
    for (Task task in input) {
      if (task.isExpired && !task.isArchived && !task.isComplete) {
        output.add(task);
      } else {
        continue;
      }
    }
    return output;
  }

  void resetAddTask() {
    tempDuration = null;
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

  Duration tempDuration;

  void changeDuration(Duration input) {
    tempDuration = input;
    notifyListeners();
  }

  Duration storedDuration() {
    return tempDuration;
  }

  DateTime tempDateTime;

  DateTime storedDateTime() {
    return tempDateTime;
  }

  void changeDateTime (DateTime dt) {
    tempDateTime = dt;
    notifyListeners();
  }
}
