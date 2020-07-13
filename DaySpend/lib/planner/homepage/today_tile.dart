import 'dart:async';

import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/reschedule.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fswitch/fswitch.dart';
import '../day2index.dart';

class TodayTaskTile extends StatefulWidget {
  final TasksBloc tasksBloc;
  final Task currentTask;
  final String taskName;
  final String taskIndex;
  final String taskTime;
  final DateTime taskDT;
  final String taskDes;
  final bool taskNotify;
  final bool taskComplete;
  final Duration taskLength;
  final bool taskOverdue;
  final Function notifyCallback;
  final Function completeCallback;
  final Function enableNotification;
  final Function disableNotification;
  final Color tileColor;
  final int taskID;
  final Function taskWidgetResetAllTask;
  final Function taskWidgetChangeNotify;
  final Function taskWidgetStoredNotify;
  final bool taskArchived;
  final bool taskExpired;

  TodayTaskTile({this.tileColor, this.taskIndex,this.taskName,this.taskTime,this.taskDT, this.taskDes,this.taskNotify, this.taskComplete, this.taskOverdue, this.notifyCallback, this.completeCallback, this.currentTask, this.taskID, this.tasksBloc, this.enableNotification, this.disableNotification, this.taskWidgetResetAllTask, this.taskWidgetChangeNotify, this.taskWidgetStoredNotify, this.taskArchived, this.taskExpired, this.taskLength});

  @override
  _TodayTaskTileState createState() => _TodayTaskTileState();
}

class _TodayTaskTileState extends State<TodayTaskTile> {
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
          color: widget.tileColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () {
            getDetails(context);
          },
          onLongPress: (widget.completeCallback),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          title: Text(
            widget.taskName,
            style: TextStyle(
                decoration: widget.taskComplete ? TextDecoration.lineThrough : null,
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (widget.taskComplete ? Icon(Icons.check_circle, color: Colors.teal, size: 22) : (widget.taskOverdue ? Icon(Icons.cancel, color: Colors.red, size: 20) : (widget.taskNotify ? Icon(Icons.notifications, color: Colors.orangeAccent, size: 20) :
              (!widget.taskOverdue && !widget.taskComplete && widget.taskDT.isBefore(DateTime.now()) ? Icon(Icons.timer, color: Colors.black, size: 22) : Icon(Icons.notifications, color: Colors.orangeAccent, size: 0))))),
              Container(
                margin: EdgeInsets.fromLTRB(12, 0, 6, 0),
                child: Text(
                  widget.taskTime,
                  style: TextStyle(
                      fontSize: 14,
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
    widget.taskWidgetResetAllTask();
    widget.taskWidgetChangeNotify(widget.taskNotify);
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
                              widget.taskName.toUpperCase(),
                              style: TextStyle(
                                  fontSize: (widget.taskName.length < 10 ? 24 : 15),
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
                                switchDays(widget.taskIndex) + ", " + widget.taskTime + "\n" + widget.taskLength.toString().split(":")[0] + "h " + widget.taskLength.toString().split(":")[1] + "m",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.1),
                              ),
                            ),
                            (widget.taskComplete ? Header(text: "Completed", italic: true, color: Colors.teal, weight: FontWeight.bold, size: 14,) : (widget.taskOverdue ? Header(text: "Overdue", color: Colors.red, weight: FontWeight.bold, size: 14, italic: true,) :
                            (widget.taskDT.isBefore(DateTime.now()) ? Header(text: "Task due", italic: true, color: Colors.amber, weight: FontWeight.bold, size: 14,) :
                            FSwitch(
                              open: widget.taskWidgetStoredNotify(),
                              width: 40,
                              height: 24,
                              openColor: Colors.teal,
                              onChanged: (v) {
                                widget.taskWidgetChangeNotify(!widget.taskWidgetStoredNotify());
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
                      (widget.taskDes!= "" ? Container(
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
                              child: (widget.taskDes!= "" ? Text(
                                widget.taskDes,
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
    ).then((value) => widget.notifyCallback());
  }
}
