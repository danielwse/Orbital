import 'dart:async';

import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/editTask.dart';
import 'package:DaySpend/planner/reschedule.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fswitch/fswitch.dart';
import 'package:random_string/random_string.dart';
import 'day2index.dart';

class TaskTile extends StatelessWidget {
  final Task currentTask;
  final String taskName;
  final String taskIndex;
  final String taskTime;
  final DateTime taskDT;
  final String taskDes;
  final bool taskNotify;
  final bool taskComplete;
  final bool taskOverdue;
  final Function notifyCallback;
  final Function completeCallback;
  final Function overdueCallback;
  final Function removeCallback;
  final Function archiveCallback;
  final Function rescheduleCallback;
  final SlidableController slidable;
  final Color tileColor;
  final TextEditingController nameEditor;
  final TextEditingController desEditor;

  TaskTile({this.tileColor, this.taskIndex,this.taskName,this.taskTime,this.taskDT, this.taskDes,this.taskNotify, this.taskComplete, this.taskOverdue, this.notifyCallback, this.completeCallback, this.overdueCallback, this.removeCallback, this.archiveCallback, this.slidable, this.rescheduleCallback, this.nameEditor, this.desEditor, this.currentTask});

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (Timer t) => (taskDT.isBefore(DateTime.now()) ? overdueCallback(t) : null));
    double heightOfActions = 52;
    return Slidable(
      key: Key(randomNumeric(5)),
      controller: slidable,
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10)),
        elevation: 7.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            onTap: () => {
              slidable.activeState?.close(),
              getDetails(context),
            },
            onLongPress: completeCallback,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            title: Text(
              taskName,
              style: TextStyle(
                  decoration: taskComplete ? TextDecoration.lineThrough : null,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (taskComplete ? Icon(Icons.check_circle, color: Colors.teal, size: 22) : (taskOverdue ? Icon(Icons.cancel, color: Colors.red, size: 20) : (taskNotify ? Icon(Icons.notifications, color: Colors.orangeAccent, size: 20) : Icon(Icons.notifications, color: Colors.orangeAccent, size: 0)))),
                Container(
                  margin: EdgeInsets.fromLTRB(12, 0, 6, 0),
                  child: Text(
                    taskTime,
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
            child: (taskComplete ?
            IconSlideAction(caption: 'Archive', color: Colors.teal, icon: Icons.archive, onTap: archiveCallback) :
            (taskOverdue ?
            RescheduleButton(updateTime: rescheduleCallback,) :
            IconSlideAction(caption: 'Archive', color: Colors.black26, icon: Icons.archive))),
        ),],
      secondaryActions: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(20)),
          height: heightOfActions,
          margin: EdgeInsets.only(right:12),
          child: EditButton(
            oldTask: currentTask,
            nameEditor: nameEditor,
            desEditor: desEditor,
            slidableController: slidable,
            taskName: taskName,
            taskDes: taskDes,
            taskOverdue: taskOverdue,
            taskDT: taskDT,
            taskComplete: taskComplete,
            taskNotify: taskNotify,
            taskTime: taskTime,
            taskIndex: taskIndex,
          ),
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
            color: (taskOverdue ? Colors.pinkAccent[100] : (taskComplete ? Colors.lightBlue[100] : Colors.blueGrey)),
            icon: Icons.delete,
            onTap: removeCallback,
          ),
        ),
      ],
    );
  }



  Future<void> getDetails(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 25,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[Expanded(
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
                          switchDays(taskIndex) + " - " + taskTime,
                          style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1),
                          ),
                      ),
                      (taskComplete ? Header(text: "Completed", italic: true, color: Colors.teal, weight: FontWeight.bold, size: 14,) : (taskOverdue ? Header(text: "Overdue", color: Colors.red, weight: FontWeight.bold, size: 14, italic: true,) : FSwitch(
                        open: (taskNotify),
                        width: 40,
                        height: 24,
                        openColor: Colors.teal,
                        onChanged: notifyCallback,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    (taskDes!= "" ? Text(
                      taskDes,
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5),
                    ) : Container()),
                  ],
                ),
              ],
            )
        );
      },
    );
  }
}

