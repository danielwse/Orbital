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

  TaskList({this.slidable, this.nameEdit, this.descriptionEdit, this.fabKey});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final TasksBloc tasksBloc = TasksBloc();

  @override
  void dispose() {
    tasksBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: tasksBloc.tasks,
      builder:
      (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        return snapshot.hasData ? Consumer<PlannerWidgetValues>(
            builder: (context, widgetData, child) {
              return GroupedListView<dynamic, String>(
                order: GroupedListOrder.ASC,
                groupBy: (task) => convertIndex(task.index), // modify index
                elements: snapshot.data,
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
                      nameEditor: widget.nameEdit,
                      desEditor: widget.descriptionEdit,
                      slidable: widget.slidable,
                      menu: widget.fabKey,
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
                        widget.fabKey.currentState.close();
                        tasksBloc.rescheduleTask(task, dt);
                      },
                      notifyCallback: (bool) {
                        widgetData.updateNotify(task);
                      },
                      completeCallback: () {
                        widget.fabKey.currentState.close();
                        if (widget.slidable.activeState != null) {
                          widget.slidable.activeState?.close();
                          Future.delayed(Duration(milliseconds: 300), () {
                            widgetData.updateComplete(task);
                          });
                        } else {
                          widgetData.updateComplete(task);
                        }
                      },
                      overdueCallback: (t) {
                        if (!task.isOverdue) {
                          widgetData.updateOverdue(task);
                          print(task.name+" overdue");
                          t.cancel();
                        }
                      },
                      removeCallback: () {
                        widget.fabKey.currentState.close();
                        widgetData.setOpacity(task);
                        Future.delayed(Duration(milliseconds: 300), () {
                          tasksBloc.removeTaskFromDatabase(task.id);
                        });
                      },
                      archiveCallback: () {
                        widget.fabKey.currentState.close();
                        //TODO : send task to another table, no need to delete
                        widgetData.setOpacity(task);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Archived Task'),
                          ),
                        );
                        Future.delayed(Duration(milliseconds: 300), () {
                          tasksBloc.removeTaskFromDatabase(task.id);
                        });
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



