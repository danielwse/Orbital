import 'package:DaySpend/planner/task_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/planner/widget_functions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

final SlidableController slidable = SlidableController();
final TextEditingController textControllerName = TextEditingController();
final TextEditingController textControllerDes = TextEditingController();

class Planner extends StatefulWidget {
  final Function notificationFn, disableNotificationFn;
  Planner({this.notificationFn, this.disableNotificationFn});
  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return ChangeNotifierProvider(
      builder: (context) => PlannerWidgetFunctions(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TaskScreen(
            disableNotificationCallback: widget.disableNotificationFn,
            notificationCallback: widget.notificationFn,
            slidable: slidable,
            nameTextControl: textControllerName,
            desTextControl: textControllerDes),
      ),
    );
  }
}
