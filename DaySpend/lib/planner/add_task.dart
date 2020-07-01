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
    String name;
    String index = getDay(datetime);
    String time = DateFormat('Hm').format(datetime).toString();
    String description;
    bool notify = false;

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
              open: notify,
              width: 40,
              height: 24,
              openColor: Colors.teal,
              onChanged: (v) {
                notify = !notify;
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
                Container(
                  height: 80,
                  width: MediaQuery.of(context).copyWith().size.width / 1.2,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: datetime,
                    onDateTimeChanged: (DateTime dt) {
                      time = DateFormat('Hm').format(dt).toString();
                      index = getDay(dt);
                    },
                    use24hFormat: true,
                    minuteInterval: 1,
                    minimumDate: datetime,
                    maximumDate: datetime.add(Duration(days: 7)),
                  ),
                )
              ],
            ),
            TextField(
              maxLength: 20,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newName) {name = newName;},
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.start,
              onChanged: (newDes) {description = newDes;},
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
                if (name != null) {
                  Provider.of<TaskFunction>(context).addTask(index,name,time,(description != null ? description : 'This task has no description'),notify,false,false);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

String getDay(DateTime dt){
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
