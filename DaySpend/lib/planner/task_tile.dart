import 'dart:async';

import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/edit_task.dart';
import 'package:DaySpend/planner/reschedule.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fswitch/fswitch.dart';
import 'day2index.dart';

class TaskTile extends StatefulWidget {
  final int mode;
  final TasksBloc tasksBloc;
  final GlobalKey<FabCircularMenuState> menu;
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
  final Function overdueCallback;
  final Function removeCallback;
  final Function archiveCallback;
  final Function rescheduleCallback;
  final Function enableNotification;
  final Function disableNotification;
  final SlidableController slidable;
  final Color tileColor;
  final TextEditingController nameEditor;
  final TextEditingController desEditor;
  final int taskID;
  final Function taskWidgetResetAllTask;
  final Function taskWidgetChangeNotify;
  final Function taskWidgetStoredNotify;
  final bool taskArchived;
  final bool taskExpired;

  TaskTile({this.tileColor, this.taskIndex,this.taskName,this.taskTime,this.taskDT, this.taskDes,this.taskNotify, this.taskComplete, this.taskOverdue, this.notifyCallback, this.completeCallback, this.overdueCallback, this.removeCallback, this.archiveCallback, this.slidable, this.rescheduleCallback, this.nameEditor, this.desEditor, this.currentTask, this.taskID, this.menu, this.tasksBloc, this.enableNotification, this.disableNotification, this.taskWidgetResetAllTask, this.taskWidgetChangeNotify, this.taskWidgetStoredNotify, this.mode, this.taskArchived, this.taskExpired, this.taskLength});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (!widget.taskComplete && widget.taskDT.add(widget.taskLength).isBefore(DateTime.now())) {
        widget.overdueCallback(t); //passed due
        try {
          t.cancel();
        } on Exception {
          print("User not on task page");
        }
      }
      if (widget.taskComplete && widget.taskExpired && !widget.taskArchived) {
        widget.archiveCallback(); // completed after overdued and expired
        try {
          t.cancel();
        } on Exception {
          print("User not on task page");
        }
      }
      if (widget.taskDT.isBefore(DateTime.now()) && widget.taskNotify) {
        widget.tasksBloc.toggleNotification(widget.currentTask); //push notification
        print(widget.taskID.toString() + " - " + widget.currentTask.id.toString());
        try {
          t.cancel();
        } on Exception {
          print("User not on task page");
        }
      }
      DateTime now = DateTime.now();
      if ((!widget.taskExpired) && (widget.taskComplete || widget.taskOverdue) && (widget.taskDT.isBefore(DateTime(now.year, now.month, now.day)))) {
        widget.tasksBloc.toggleExpired(widget.currentTask);
        print(widget.taskName + " has expired");
        try {
          t.cancel();
        } on Exception {
          print("User not on task page");
        }
      }
    });
    double heightOfActions = 52;
    return Slidable(
      key: Key(widget.taskID.toString()),
      controller: widget.slidable,
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      child: Card(
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
              widget.menu.currentState.close();
              widget.slidable.activeState?.close();
              getDetails(context);
            },
            onLongPress: (widget.mode != 2 ? widget.completeCallback : null),
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
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(20)),
          margin: EdgeInsets.only(left: 12),
          height: heightOfActions,
          child: pickSlideMainAction(),
        ),
      ],
      secondaryActions: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(20)),
          height: heightOfActions,
          margin: EdgeInsets.only(right:12),
          child: pickSlideSecondaryAction(),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(20)),
          margin: EdgeInsets.only(right: 12),
          height: heightOfActions,
          child: IconSlideAction(
            closeOnTap: true,
            caption: 'Delete',
            color: Colors.blueGrey,
            icon: Icons.delete,
            onTap: widget.removeCallback,
          ),
        ),
        SizedBox(
          height: heightOfActions,
        )
      ],
    );
  }

  pickSlideMainAction() {
    if (widget.taskComplete && widget.mode == 1) {
      return IconSlideAction(caption: 'Archive',
          color: Colors.teal,
          icon: Icons.archive,
          onTap: widget.archiveCallback);
    } else if (widget.taskArchived && widget.mode == 2) {
      return RescheduleButton(updateTime: widget.rescheduleCallback, color: Colors.teal[100]);
    } else if (widget.taskOverdue) {
      return RescheduleButton(updateTime: widget.rescheduleCallback, color: Colors.redAccent[100]);
    } else {
      return IconSlideAction(caption: 'Pending', color: Colors.black26, icon: Icons.access_time);
    }
  }

  pickSlideSecondaryAction() {
    if (!widget.taskOverdue && !widget.taskComplete && widget.taskDT.isBefore(DateTime.now())) {
      return IconSlideAction(caption: 'Due', color: Colors.amber, icon: Icons.access_time);
    } else if (widget.taskOverdue && !widget.taskComplete) {
      return IconSlideAction(caption: 'Overdue', color: Colors.redAccent[100], icon: Icons.cancel);
    } else if (widget.taskComplete) {
      return IconSlideAction(caption: 'Done', color: Colors.teal[100], icon: Icons.check_circle);
    } else {
      return EditButton(
        enableNotification: widget.enableNotification,
        disableNotification: widget.disableNotification,
        taskID: widget.taskID,
        oldTask: widget.currentTask,
        nameEditor: widget.nameEditor,
        desEditor: widget.desEditor,
        slidableController: widget.slidable,
        taskName: widget.taskName,
        taskDes: widget.taskDes,
        taskOverdue: widget.taskOverdue,
        taskDT: widget.taskDT,
        taskComplete: widget.taskComplete,
        taskNotify: widget.taskNotify,
        taskTime: widget.taskTime,
        taskIndex: widget.taskIndex,
        menu: widget.menu,
        tasksBloc: widget.tasksBloc,
        taskLength: widget.taskLength,
      );
    }
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

