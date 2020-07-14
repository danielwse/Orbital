import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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

String switchDays(i) {
  switch (i) {
    case '1':
      return 'Monday';
      break;
    case '2':
      return 'Tuesday';
      break;
    case '3':
      return 'Wednesday';
      break;
    case '4':
      return 'Thursday';
      break;
    case '5':
      return 'Friday';
      break;
    case '6':
      return 'Saturday';
      break;
    case '7':
      return 'Sunday';
      break;
    default:
      return '';
  }
}

String getIndex(DateTime dt){
  String i;
  switch (DateFormat('EEEE').format(dt).toString()) {
    case 'Monday': i = '1'; break;
    case 'Tuesday': i = '2'; break;
    case 'Wednesday': i = '3'; break;
    case 'Thursday': i = '4'; break;
    case 'Friday': i = '5'; break;
    case 'Saturday': i = '6'; break;
    case 'Sunday': i = '7'; break;
  }
  return i;
}

String convertIndex(String index) {
  int currIndex = int.parse(getIndex(DateTime.now()));
  int n = currIndex - 1;
  int inputIndex = int.parse(index);
  int output = inputIndex - n;
  if (inputIndex <= n) {
    output += 7;
  }
  return output.toString();
}

String revertIndex(String index) {
  int currIndex = int.parse(getIndex(DateTime.now()));
  int n = currIndex - 1;
  int inputIndex = int.parse(index);
  int output = inputIndex + n;
  if (output > 7) {
    output -= 7;
  }
  return output.toString();
}
