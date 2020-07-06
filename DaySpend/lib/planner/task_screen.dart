import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task_function.dart';
import 'package:DaySpend/planner/task_list.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/planner/add_task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

final SlidableController slidable = SlidableController();

SlidableController get getSlidable {
  return slidable;
}

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: AppBar(
        title: Header(
          text: 'DaySpend',
          italic: true,
          size: 20,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () => {
              Provider.of<TaskFunction>(context).resetAddTask(),
              getSlidable.activeState?.close(),
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child:Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: AddTask(),
                  )
                )
              ),
            },
            icon: Padding(
              padding: const EdgeInsets.only(right: 100),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: TaskList(
        slidable: getSlidable,
      ),
    );
  }
}