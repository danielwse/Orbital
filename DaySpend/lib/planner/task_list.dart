import 'dart:async';

import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:DaySpend/planner/widget_functions.dart';
import 'package:DaySpend/planner/task_tile.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

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
        return snapshot.hasData ? Consumer<PlannerWidgetFunctions>(
            builder: (context, widgetData, child) {
              return GroupedListView<dynamic, String>(
                order: GroupedListOrder.ASC,
                separator: SizedBox(
                  height: 12,
                ),
                groupBy: (task) => convertIndex(task.index), // modify index
                elements: (widget.mode == 1 ? widgetData.getRecent(snapshot.data) : (widget.mode == 2 ? widgetData.getArchived(snapshot.data) : widgetData.getOverdue(snapshot.data))),
                groupSeparatorBuilder: (index) => Padding(
                  padding: (revertIndex(index) == getIndex(DateTime.now())
                      ? EdgeInsets.fromLTRB(15, 30, 10, 10)
                      : EdgeInsets.fromLTRB(15, 40, 10, 10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                        child: Header(
                          text: switchDays(revertIndex(index)),
                          shadow: Shadow(blurRadius: 2.5, color: Colors.black26, offset: Offset(0,1)),
                          weight: FontWeight.w600, color: Colors.black54, size: MediaQuery.of(context).copyWith().size.width/15,
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
                      taskLength: task.length,
                      taskNotify: task.notify,
                      taskComplete: task.isComplete,
                      taskOverdue: task.isOverdue,
                      taskArchived: task.isArchived,
                      taskExpired: task.isExpired,
                      rescheduleCallback: (DateTime dt, Duration duration) {
                        widget.fabKey.currentState.close();
                        widgetData.setOpacity(task);
                        widget.tasksBloc.rescheduleTask(task, dt, duration);
                      },
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
                        widget.fabKey.currentState.close();
                        if (widget.slidable.activeState != null) {
                          widget.slidable.activeState?.close();
                          Future.delayed(Duration(milliseconds: 300), () {
                            widget.tasksBloc.toggleComplete(task);
                          });
                        } else {
                          widget.tasksBloc.toggleComplete(task);
                        }
                        if (changeToCompleted && taskHasNotifications) {
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
                        }
                      },
                      removeCallback: () async {
                        widget.fabKey.currentState.close();
                        widgetData.setOpacity(task);
                        if (task.notify) {
                          widget.tasksBloc.toggleNotification(task);
                          widget.disableNotificationFn(task.id);
                        }
                        Future.delayed(Duration(milliseconds: 300), () async {
                          await widget.tasksBloc.removeTaskFromDatabase(task.id);
                        });
                      },
                      archiveCallback: () {
                        if (!task.isComplete) {
                          widget.tasksBloc.toggleComplete(task);
                        }
                        if (task.notify) {
                          widget.tasksBloc.toggleNotification(task);
                          widget.disableNotificationFn(task.id);
                        }
                        widget.tasksBloc.toggleArchived(task);
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
                      updateTaskCallback: (index, name, time, description, notify, dt, duration) async {
                        if (task.notify) {
                          print("disabled previous notification");
                          widget.tasksBloc.toggleNotification(task);
                          widget.disableNotificationFn(task.id);
                        }
                        await widget.tasksBloc.updateTask(task, index, name, time, description, notify, dt, duration);
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



