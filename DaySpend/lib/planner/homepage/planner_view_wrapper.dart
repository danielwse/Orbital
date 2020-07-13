import 'package:DaySpend/planner/homepage/planner_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/planner/widget_functions.dart';
import 'package:provider/provider.dart';

class PlannerHome extends StatefulWidget {
  final Function notificationFn;
  final Function disableNotificationFn;
  PlannerHome({this.notificationFn, this.disableNotificationFn});
  @override
  _PlannerHomeState createState() => _PlannerHomeState();
}

class _PlannerHomeState extends State<PlannerHome> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // ignore: missing_required_param
      child: ChangeNotifierProvider(
        builder: (context) => PlannerWidgetFunctions(),
        child: TaskView(disableNotificationCallback: widget.disableNotificationFn, notificationCallback: widget.notificationFn),
      ),
    );
  }
}
