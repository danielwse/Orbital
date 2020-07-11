import 'package:DaySpend/planner/task_screen.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/planner/widget_values.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

final SlidableController slidable = SlidableController();
final TextEditingController textControllerName = TextEditingController();
final TextEditingController textControllerDes = TextEditingController();

SlidableController get getSlidable {
  return slidable;
}

TextEditingController get getNameText {
  return textControllerName;
}

TextEditingController get getDesText {
  return textControllerDes;
}

class Planner extends StatefulWidget {
  final Function notificationFn;
  final Function disableNotificationFn;
  Planner({this.notificationFn, this.disableNotificationFn});
  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  final GlobalKey<FabCircularMenuState> plannerFabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return ChangeNotifierProvider(
      builder: (context) => PlannerWidgetValues(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TaskScreen(disableNotificationCallback: widget.disableNotificationFn, notificationCallback: widget.notificationFn,
            slidable: getSlidable, nameTextControl: textControllerName, desTextControl: textControllerDes,
            fabKey: plannerFabKey),
      ),
    );
  }
}
