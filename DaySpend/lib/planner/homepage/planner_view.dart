import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/planner/homepage/today_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/planner/widget_functions.dart';
import 'package:provider/provider.dart';

class PlannerHome extends StatefulWidget {
  final Function notificationFn, disableNotificationFn;
  PlannerHome({this.notificationFn, this.disableNotificationFn});
  @override
  _PlannerHomeState createState() => _PlannerHomeState();
}

class _PlannerHomeState extends State<PlannerHome> {

  final TasksBloc tasksBloc = TasksBloc();

  @override
  void dispose() {
    tasksBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.width,
      // ignore: missing_required_param
      child: ChangeNotifierProvider(
        builder: (context) => PlannerWidgetFunctions(),
        child: TodayTaskList(tasksBloc: tasksBloc, disableNotificationFn: widget.disableNotificationFn, notificationFn: widget.notificationFn),
      ),
    );
  }
}
