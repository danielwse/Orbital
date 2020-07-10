import 'dart:async';

import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task_function.dart';
import 'package:DaySpend/planner/task_tile.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'day2index.dart';

class TaskList extends StatelessWidget {
  final SlidableController slidable;
  final TextEditingController nameEdit;
  final TextEditingController descriptionEdit;
  final GlobalKey<FabCircularMenuState> fabKey;

  TaskList({this.slidable, this.nameEdit, this.descriptionEdit, this.fabKey});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFunction>(
      builder: (context, taskData, child) {
        return GroupedListView<dynamic, String>(
          order: GroupedListOrder.ASC,
          groupBy: (task) => convertIndex(task.index), // modify index
          elements: taskData.mainTasks,
          groupSeparatorBuilder: (index) => Padding(
            padding: (revertIndex(index) == getIndex(DateTime.now())
                ? EdgeInsets.fromLTRB(15, 10, 10, 10)
                : EdgeInsets.fromLTRB(15, 40, 10, 10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(
                  text: switchDays(revertIndex(index)),
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
                taskID: task.id,
                currentTask: task,
                nameEditor: nameEdit,
                desEditor: descriptionEdit,
                slidable: slidable,
                menu: fabKey,
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
                  fabKey.currentState.close();
                  taskData.rescheduleOverdue(task, dt);
//                  TaskScreenFunctions().transferTasksToDatabase();
                  },
                notifyCallback: (bool) {
                  taskData.updateNotify(task);
//                  TaskScreenFunctions().transferTasksToDatabase();
                  },
                completeCallback: () {
                  fabKey.currentState.close();
                  if (slidable.activeState != null) {
                    slidable.activeState?.close();
                    Future.delayed(Duration(milliseconds: 300), () {
                      taskData.updateComplete(task);
                    });
                  } else {
                    taskData.updateComplete(task);
                  }
//                  TaskScreenFunctions().transferTasksToDatabase();
                  },
                overdueCallback: (t) {
                  if (!task.isOverdue) {
                    taskData.updateOverdue(task);
                    print(task.name+" overdue");
                    t.cancel();
                  }
//                  TaskScreenFunctions().transferTasksToDatabase();
                  },
                removeCallback: () {
                  fabKey.currentState.close();
                  taskData.setOpacity(task);
                  Future.delayed(Duration(milliseconds: 300), () {
                    taskData.deleteTask(task);
                  });
//                  TaskScreenFunctions().transferTasksToDatabase();
                  },
                archiveCallback: () {
                  fabKey.currentState.close();
                  taskData.archiveTask(task);
                  taskData.setOpacity(task);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Archived Task'),
                    ),
                  );
                  Future.delayed(Duration(milliseconds: 300), () {
                  taskData.deleteTask(task);
                  });
//                  TaskScreenFunctions().transferTasksToDatabase();
                  },
                ),
            );
          },
        );
      }
    );
  }
}



