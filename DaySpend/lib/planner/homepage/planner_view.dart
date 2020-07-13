import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/planner/homepage/today_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskView extends StatefulWidget {
  final Function notificationCallback;
  final Function disableNotificationCallback;

  TaskView({this.notificationCallback, this.disableNotificationCallback});

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {

  final TasksBloc tasksBloc = TasksBloc();

  @override
  void dispose() {
    tasksBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return TodayTaskList(
      notificationFn: widget.notificationCallback,
      disableNotificationFn: widget.disableNotificationCallback,
      tasksBloc: tasksBloc,
    );
  }
}