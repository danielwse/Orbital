import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class PlannerWidgetValues extends ChangeNotifier {

  //might move this to db, but if working, leave it
  void setOpacity(Task task) {
    task.toggleAnimate();
    notifyListeners();
  }

  List<Task> filterArchived(List<Task> input) {
    List<Task> output = [];
    for (Task task in input) {
      if (task.isArchived) {
        continue;
      } else {
        output.add(task);
      }
    }
    return output;
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
}
