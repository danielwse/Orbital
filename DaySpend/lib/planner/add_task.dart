import 'package:DaySpend/planner/picker.dart';
import 'package:DaySpend/planner/task_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fswitch/fswitch.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime datetime = DateTime.now();

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            FSwitch(
              open: Provider.of<TaskFunction>(context).storedNotify(),
              width: 40,
              height: 24,
              openColor: Colors.teal,
              onChanged: (v) {
                Provider.of<TaskFunction>(context).changeNotify(!Provider.of<TaskFunction>(context).storedNotify());
              },
              closeChild: Icon(
                Icons.notifications_off,
                size: 12,
                color: Colors.brown,
              ),
              openChild: Icon(
                Icons.notifications,
                size: 12,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PickerButton(
                  initDateTime: datetime,
                ),
              ],
            ),
            Container(
              height: 50,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius:
                  BorderRadius.circular(10)),
              child: TextField(
                  maxLength: 20,
                  autofocus: true,
                  textAlign: TextAlign.start,
                  onChanged: (String newName) {
                    Provider.of<TaskFunction>(context).changeName(newName);
                    },
                  showCursor: true,
                  maxLengthEnforced: true,
                  decoration:
                  InputDecoration.collapsed(
                    hintText: 'Task Name',
                  )
              ),
            ),
            Container(
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius:
                  BorderRadius.circular(10)),
              child: TextField(
                  autofocus: false, maxLines: null,
                  textAlign: TextAlign.start,
                  onChanged: (String newDes) {
                    Provider.of<TaskFunction>(context).changeDes(newDes);
                  },
                  showCursor: true,
                  maxLengthEnforced: true,
                  decoration:
                  InputDecoration.collapsed(
                    hintText: 'Task Description',
                  )
              ),
            ),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
                String name = Provider.of<TaskFunction>(context).storedName();
                if (name != null) {
                  DateTime setTime = Provider.of<TaskFunction>(context).storedDateTime();
                  print("from add task" + setTime.toString());
                  String index = getIndex(setTime);
                  String time = DateFormat('Hm').format(setTime).toString();
                  String description = Provider.of<TaskFunction>(context).storedDes();
                  bool notify = Provider.of<TaskFunction>(context).storedNotify();
                  Provider.of<TaskFunction>(context).addTask(index,name,time,(description != null ? description : 'This task has no description'), notify, setTime);
                }
                Provider.of<TaskFunction>(context).resetAddTask();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
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
}
