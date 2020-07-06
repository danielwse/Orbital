import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/picker.dart';
import 'package:DaySpend/planner/task_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fswitch/fswitch.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime datetime = DateTime.now();

    return Consumer<TaskFunction>(
      builder: (context, newTask, child) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Header(
                              weight: FontWeight.bold,
                              italic: false,
                              text: "Add ",
                              color: Colors.black, size: 44,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Header(
                              weight: FontWeight.bold,
                              italic: false,
                              text: "task",
                              color: Colors.amber,
                              size: 32,
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Header(
                                weight: FontWeight.bold,
                                italic: false,
                                text: "Notification : ",
                                color: Colors.black, size: 15,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 13),
                              child: FSwitch(
                                open: newTask.storedNotify(),
                                width: 48,
                                height: 28,
                                openColor: Colors.teal,
                                onChanged: (v) {
                                  newTask.changeNotify(!newTask.storedNotify());
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
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 10, 10),
                          child: PickerButton(
                            initDateTime: datetime.add(Duration(minutes: 1)),
                          ),
                        ),
                      ],
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
                        newTask.changeName(newName);
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
                      horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius:
                      BorderRadius.circular(10)),
                  child: TextField(
                      autofocus: false, maxLines: null,
                      textAlign: TextAlign.start,
                      onChanged: (String newDes) {
                        newTask.changeDes(newDes);
                      },
                      showCursor: true,
                      maxLengthEnforced: true,
                      decoration:
                      InputDecoration.collapsed(
                        hintText: 'Task Description',
                      )
                  ),
                ),
                NiceButton(
                  width: 100,
                  elevation: 8.0,
                  radius: 52.0,
                  fontSize: 16,
                  text: "Add",
                  textColor: Colors.white,
                  background: Colors.teal,
                  onPressed: () {
                    String name = newTask.storedName();
                    if (name != null) {
                      DateTime setTime = newTask.storedDateTime();
                      print("from add task" + setTime.toString());
                      if (setTime == null) {
                        setTime = DateTime.now();
                      }
                      String index = getIndex(setTime);
                      String time = DateFormat('Hm').format(setTime).toString();
                      String description = newTask.storedDes();
                      bool notify = newTask.storedNotify();
                      newTask.addTask(index,name,time,(description != null ? description : 'This task has no description'), notify, setTime);
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
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
