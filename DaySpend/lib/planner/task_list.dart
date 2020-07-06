import 'dart:async';

import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task_function.dart';
import 'package:DaySpend/planner/task_tile.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import 'day2index.dart';

class TaskList extends StatelessWidget {
  final SlidableController slidable;

  TaskList({this.slidable});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFunction>(
      builder: (context, taskData, child) {
        return GroupedListView<dynamic, String>(
          order: GroupedListOrder.ASC,
          groupBy: (task) => task.index,
          elements: taskData.tasks,
          groupSeparatorBuilder: (index) => Padding(
            padding: (index == '1'
                ? EdgeInsets.fromLTRB(15, 10, 10, 10)
                : EdgeInsets.fromLTRB(15, 40, 10, 10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(
                  text: switchDays(index),
                  size: 20,
                ),
              ],
            ),
          ),
          itemBuilder: (context, task) {
            print(task.opacity);
            return OpacityAnimatedWidget.tween(
              enabled: true,
              opacityDisabled: 1,
              opacityEnabled: task.opacity,
              child: TaskTile(
                slidable: slidable,
                tileColor: (task.isComplete ? Colors.tealAccent[100] : (task.isOverdue ? Colors.red[100] : Colors.white)),
                taskName: task.name,
                taskIndex: task.index,
                taskTime: task.time,
                taskDes: task.description,
                taskDT: task.dt,
                taskNotify: task.notify,
                taskComplete: task.isComplete,
                taskOverdue: task.isOverdue,
                rescheduleCallback: (DateTime dt) {
                  taskData.rescheduleOverdue(task, dt);},
                notifyCallback: (bool) {
                  taskData.updateNotify(task);},
                completeCallback: () {
                  if (slidable.activeState != null) {
                    slidable.activeState?.close();
                    Future.delayed(Duration(milliseconds: 300), () {
                      taskData.updateComplete(task);
                    });
                  } else {
                    taskData.updateComplete(task);
                  }
                  },
                overdueCallback: (t) {
                  if (!task.isOverdue) {
                    taskData.updateOverdue(task);
                    print(task.name+" overdue");
                    t.cancel();
                  }
                  },
                removeCallback: () {
                  taskData.setOpacity(task);
                  Future.delayed(Duration(milliseconds: 300), () {
                    taskData.deleteTask(task);
                  });},
                archiveCallback: () {
                  taskData.archiveTask(task);
                  taskData.setOpacity(task);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Archived Task'),
                    ),
                  );
                  Future.delayed(Duration(milliseconds: 300), () {
                  taskData.deleteTask(task);
                  });},
                ),
            );
          },
        );
      }
    );
  }
}



