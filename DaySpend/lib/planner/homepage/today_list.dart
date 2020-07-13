import 'dart:async';

import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:DaySpend/planner/homepage/today_tile.dart';
import 'package:DaySpend/planner/widget_functions.dart';
import 'package:DaySpend/planner/task_tile.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import '../day2index.dart';

class TodayTaskList extends StatefulWidget {
  final TasksBloc tasksBloc;
  final Function notificationFn;
  final Function disableNotificationFn;

  TodayTaskList({this.tasksBloc, this.notificationFn, this.disableNotificationFn});

  @override
  _TodayTaskListState createState() => _TodayTaskListState();
}

class _TodayTaskListState extends State<TodayTaskList> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.tasksBloc.tasks,
      builder:
          (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        return snapshot.hasData ? Consumer<PlannerWidgetFunctions>(
            builder: (context, widgetData, child) {
              return widgetData.getTodayTasks(snapshot.data).length != 0 ? GroupedListView<dynamic, String>(
                order: GroupedListOrder.ASC,
                separator: SizedBox(
                  height: 12,
                ),
                groupBy: (task) => convertIndex(task.index), // modify index
                elements: widgetData.getTodayTasks(snapshot.data),
                groupSeparatorBuilder: (index) => Padding(
                  padding: (revertIndex(index) == getIndex(DateTime.now())
                      ? EdgeInsets.fromLTRB(15, 30, 10, 10)
                      : EdgeInsets.fromLTRB(15, 40, 10, 10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                        child: Header(
                          text: "Today's Task",
                          shadow: Shadow(blurRadius: 2.5, color: Colors.black26, offset: Offset(0,1)),
                          weight: FontWeight.w600, color: Colors.black54, size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, task) {
                  return OpacityAnimatedWidget.tween(
                    enabled: true,
                    opacityDisabled: 1,
                    opacityEnabled: task.opacity,
                    child: TodayTaskTile(
                      enableNotification: widget.notificationFn,
                      tasksBloc: widget.tasksBloc,
                      taskID: task.id,
                      currentTask: task,
                      tileColor: (task.isComplete ? Colors.tealAccent[100] : (task.isOverdue ? Colors.red[100] : (task.dt.isBefore(DateTime.now()) ? Colors.amber[100] : Colors.white))),
                      taskName: task.name,
                      taskIndex: task.index,
                      taskTime: task.time,
                      taskDes: task.description,
                      taskDT: task.dt,
                      taskLength: task.length,
                      taskNotify: task.notify,
                      taskComplete: task.isComplete,
                      taskOverdue: task.isOverdue,
                      taskArchived: task.isArchived,
                      taskExpired: task.isExpired,
                      notifyCallback: () {
                        if (!task.dt.isBefore(DateTime.now())) {
                          if (widgetData.storedNotify() != task.notify) {
                            widget.tasksBloc.toggleNotification(task);
                          }
                          if (widgetData.storedNotify()) {
                            widget.notificationFn(task.id, task.name, task.dt);
                          } else {
                            widget.disableNotificationFn(task.id);
                          }
                        }
                      },
                      completeCallback: () {
                        bool changeToCompleted = false;
                        bool taskHasNotifications = false;
                        if (!task.isComplete) {
                          changeToCompleted = true;
                        }
                        if (task.notify) {
                          taskHasNotifications = true;
                        }
                        widget.tasksBloc.toggleComplete(task);
                        if (changeToCompleted && taskHasNotifications) {
                          widget.tasksBloc.toggleNotification(task);
                          widget.disableNotificationFn(task.id);
                        }
                      },
                      taskWidgetResetAllTask: () {
                        widgetData.resetAddTask();
                      },
                      taskWidgetChangeNotify: (bool b) {
                        widgetData.changeNotify(b);
                      },
                      taskWidgetStoredNotify: () {
                        return widgetData.storedNotify();
                      },
                    ),
                  );
                },
              ) : Container(
                alignment: Alignment.center,
                child: Text("You have no tasks set for today\n\nAdd a new task\n\n\n →",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                ),),
              );
            }
        ) : Container();
      },
    );
  }
}