import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task_function.dart';
import 'package:DaySpend/planner/task_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFunction>(
      builder: (context, taskData, child) {
        return GroupedListView<dynamic, String>(
          order: GroupedListOrder.ASC,
          groupBy: (task) => task.index,
          elements: taskData.tasks,
          groupSeparatorBuilder: (index) => Padding(
            padding: (index == '1'
                ? EdgeInsets.fromLTRB(15, 10, 10, 10)
                : EdgeInsets.fromLTRB(15, 40, 10, 10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(
                  text: switchDays(index),
                  size: 20,
                  italic: false,
                ),
              ],
            ),
          ),
          itemBuilder: (context, task) {
            return TaskTile(
              taskName: task.name,
              taskIndex: task.index,
              taskTime: task.time,
              taskDes: task.description,
              taskNotify: task.notify,
              taskComplete: task.isComplete,
              taskOverdue: task.isOverdue,
            );
          },
        );
      }
    );
  }
}


