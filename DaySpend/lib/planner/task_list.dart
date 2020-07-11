import 'dart:async';

import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:DaySpend/planner/widget_values.dart';
import 'package:DaySpend/planner/task_tile.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'day2index.dart';

class TaskList extends StatefulWidget {
  final SlidableController slidable;
  final TextEditingController nameEdit;
  final TextEditingController descriptionEdit;
  final GlobalKey<FabCircularMenuState> fabKey;
  final TasksBloc tasksBloc;
  final Function notificationFn;
  final Function disableNotificationFn;
  final int mode;

  TaskList({this.slidable, this.nameEdit, this.descriptionEdit, this.fabKey, this.tasksBloc, this.notificationFn, this.disableNotificationFn, this.mode});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.tasksBloc.tasks,
      builder:
      (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        return snapshot.hasData ? Consumer<PlannerWidgetValues>(
            builder: (context, widgetData, child) {
              return GroupedListView<dynamic, String>(
                order: GroupedListOrder.ASC,
                groupBy: (task) => convertIndex(task.index), // modify index
                elements: (widget.mode == 1 ? widgetData.filterArchived(snapshot.data) : (widget.mode == 2 ? widgetData.getArchived(snapshot.data) :
//                (widget.mode == 3 ? widgetData.getExpired(snapshot.data) :
                snapshot.data )),
                groupSeparatorBuilder: (index) => Padding(
                  padding: (revertIndex(index) == getIndex(DateTime.now())
                      ? EdgeInsets.fromLTRB(15, 20, 10, 10)
                      : EdgeInsets.fromLTRB(15, 30, 10, 10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Header(
                        text: switchDays(revertIndex(index)),
                        shadow: Shadow(blurRadius: 2.5, color: Colors.black26, offset: Offset(0,1)),
                        weight: FontWeight.w600, color: Colors.black54, size: 20,
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
                      mode: widget.mode,
                      enableNotification: widget.notificationFn,
                      tasksBloc: widget.tasksBloc,
                      taskID: task.id,
                      currentTask: task,
                      nameEditor: widget.nameEdit,
                      desEditor: widget.descriptionEdit,
                      slidable: widget.slidable,
                      menu: widget.fabKey,
                      tileColor: (task.isComplete ? Colors.tealAccent[100] : (task.isOverdue ? Colors.red[100] : (task.dt.isBefore(DateTime.now()) ? Colors.amber[100] : Colors.white))),
                      taskName: task.name,
                      taskIndex: task.index,
                      taskTime: task.time,
                      taskDes: task.description,
                      taskDT: task.dt,
                      taskNotify: task.notify,
                      taskComplete: task.isComplete,
                      taskOverdue: task.isOverdue,
                      rescheduleCallback: (DateTime dt) {
                        widget.fabKey.currentState.close();
                        widget.tasksBloc.rescheduleTask(task, dt);
                      },
                      notifyCallback: () {
                        if (widgetData.storedNotify() != task.notify) {
                          widget.tasksBloc.toggleNotification(task);
                        }
                        if (widgetData.storedNotify()) {
                          widget.notificationFn(task.id, task.name, task.dt);
                        } else {
                          widget.disableNotificationFn(task.id);
                        }
                      },
                      completeCallback: () {
                        widget.fabKey.currentState.close();
                        if (widget.slidable.activeState != null) {
                          widget.slidable.activeState?.close();
                          Future.delayed(Duration(milliseconds: 300), () {
                            widget.tasksBloc.toggleComplete(task);
                          });
                        } else {
                          widget.tasksBloc.toggleComplete(task);
                        }
                        if (task.isComplete && task.notify) {
                          widget.tasksBloc.toggleNotification(task);
                          widget.disableNotificationFn(task.id);
                        }
                      },
                      overdueCallback: (t) {
                        if (!task.isOverdue) {
                          widget.tasksBloc.toggleOverdue(task);
                          if (task.notify) {
                            widget.tasksBloc.toggleNotification(task);
                            widget.disableNotificationFn(task.id);
                          }
                          print(task.name+" overdue");
                          t.cancel();
                        }
                      },
                      removeCallback: () {
                        widget.fabKey.currentState.close();
                        widgetData.setOpacity(task);
                        if (task.notify) {
                          widget.tasksBloc.toggleNotification(task);
                          widget.disableNotificationFn(task.id);
                        }
                        Future.delayed(Duration(milliseconds: 300), () {
                          widget.tasksBloc.removeTaskFromDatabase(task.id);
                        });
                      },
                      archiveCallback: () {
                        widget.fabKey.currentState.close();
                        widget.tasksBloc.toggleArchived(task);
                        if (task.notify) {
                          widget.tasksBloc.toggleNotification(task);
                          widget.disableNotificationFn(task.id);
                        }
                        widgetData.setOpacity(task);
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
              );
            }
        ) : Container();
      },
    );
  }
}



