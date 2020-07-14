import 'dart:async';

import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fswitch/fswitch.dart';
import '../widget_functions.dart';

class TodayTaskTile extends StatelessWidget {
  final TasksBloc tasksBloc;
  final Task currentTask;
  final String taskName, taskIndex, taskTime, taskDes;
  final DateTime taskDT;
  final Duration taskLength;
  final Function notifyCallback, completeCallback, enableNotification, disableNotification;
  final Color tileColor;
  final int taskID;
  final Function taskWidgetResetAllTask, taskWidgetChangeNotify, taskWidgetStoredNotify;
  final bool taskArchived, taskExpired, taskNotify, taskComplete, taskOverdue;

  TodayTaskTile({this.tileColor, this.taskIndex,this.taskName,this.taskTime,this.taskDT, this.taskDes,this.taskNotify, this.taskComplete, this.taskOverdue, this.notifyCallback, this.completeCallback, this.currentTask, this.taskID, this.tasksBloc, this.enableNotification, this.disableNotification, this.taskWidgetResetAllTask, this.taskWidgetChangeNotify, this.taskWidgetStoredNotify, this.taskArchived, this.taskExpired, this.taskLength});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(10)),
      elevation: 7.0,
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () {
            getDetails(context);
          },
          onLongPress: (completeCallback),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          title: Text(
            taskName,
            style: TextStyle(
                decoration: taskComplete ? TextDecoration.lineThrough : null,
                fontSize: MediaQuery.of(context).copyWith().size.width/25,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (taskComplete ? Icon(Icons.check_circle, color: Colors.teal, size: MediaQuery.of(context).copyWith().size.width/25,) : (taskOverdue ? Icon(Icons.cancel, color: Colors.red, size: MediaQuery.of(context).copyWith().size.width/25) : (taskNotify ? Icon(Icons.notifications, color: Colors.orangeAccent, size: MediaQuery.of(context).copyWith().size.width/25) :
              (!taskOverdue && !taskComplete && taskDT.isBefore(DateTime.now()) ? Icon(Icons.timer, color: Colors.black, size: MediaQuery.of(context).copyWith().size.width/25) : Icon(Icons.notifications, color: Colors.orangeAccent, size: 0))))),
              Container(
                margin: EdgeInsets.fromLTRB(12, 0, 6, 0),
                child: Text(
                  taskTime,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).copyWith().size.width/30,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getDetails(BuildContext context) {
    taskWidgetResetAllTask();
    taskWidgetChangeNotify(taskNotify);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10)),
            content: Container(
              width: double.minPositive,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[Flexible(
                            child: Text(
                              taskName.toUpperCase(),
                              style: TextStyle(
                                  fontSize: (taskName.length < 10 ? 24 : 15),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5),
                            ),
                          ),],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                switchDays(taskIndex) + ", " + taskTime + "\n" + taskLength.toString().split(":")[0] + "h " + taskLength.toString().split(":")[1] + "m",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.1),
                              ),
                            ),
                            (taskComplete ? Header(text: "Completed", italic: true, color: Colors.teal, weight: FontWeight.bold, size: 14,) : (taskOverdue ? Header(text: "Overdue", color: Colors.red, weight: FontWeight.bold, size: 14, italic: true,) :
                            (taskDT.isBefore(DateTime.now()) ? Header(text: "Task due", italic: true, color: Colors.amber, weight: FontWeight.bold, size: 14,) :
                            FSwitch(
                              open: taskWidgetStoredNotify(),
                              width: 40,
                              height: 24,
                              openColor: Colors.teal,
                              onChanged: (v) {
                                taskWidgetChangeNotify(!taskWidgetStoredNotify());
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
                            )
                            ))),
                          ],
                        ),
                      ),
                      (taskDes!= "" ? Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                        child: Divider(
                          color: Colors.blueGrey,
                        ),
                      ): Container()),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: (taskDes!= "" ? Text(
                                taskDes,
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5),
                              ) : Container()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        );
      },
    ).then((value) => notifyCallback());
  }
}
