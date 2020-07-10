import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task_function.dart';
import 'package:DaySpend/planner/task_list.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/planner/add_task.dart';
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

class TaskScreen extends StatelessWidget {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  void toggleMenu({bool forceClose}) {
    if (fabKey.currentState.isOpen) {
      fabKey.currentState.close();
    } else {
      if (forceClose) {
        fabKey.currentState.close();
      } else {
        fabKey.currentState.open();
      }
    }
  }
  GlobalKey<FabCircularMenuState> get menuKey {
    return fabKey;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF7F7F7),
        appBar: AppBar(
          titleSpacing: 8,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Header(
                      text: 'Day',
                      weight: FontWeight.bold,
                      size: 24,
                      color: Colors.teal,
                      underline: true,
                      italic: true,
                      shadow: Shadow(
                        blurRadius: 4.0,
                        color: Colors.blueAccent[100],
                        offset: Offset(1.0, 1.0),
                      ),
                    ),
                    Header(
                      text: 'Spend',
                      size: 24,
                      color: Colors.grey,
                      italic: true,
                      weight: FontWeight.bold,
                      shadow: Shadow(
                        blurRadius: 2.0,
                        color: Colors.blueGrey[100],
                        offset: Offset(1.0, 1.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: RawMaterialButton(
                constraints: BoxConstraints.tight(Size(40, 40)),
                fillColor: Colors.white,
                shape: CircleBorder(),
                elevation: 8,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  Provider.of<TaskFunction>(context).resetAddTask();
                  toggleMenu(forceClose: true);
                  getSlidable.activeState?.close();
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                          child:Container(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: AddTask(),
                          )
                      )
                  );
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onPanDown: (v) {
            getSlidable.activeState?.close();
            toggleMenu(forceClose: true);
          },
          child: TaskList(
            slidable: getSlidable,
            nameEdit: getNameText,
            descriptionEdit: getDesText,
            fabKey: fabKey,
          ),
        ),
        floatingActionButton: FabCircularMenu(
          key: fabKey,
          fabOpenIcon: Icon(Icons.home),
          fabColor: Colors.white,
          ringColor: Colors.lightBlue[100],
          ringDiameter: MediaQuery.of(context).copyWith().size.width * 0.8,
          ringWidth: MediaQuery.of(context).copyWith().size.width * 1.25 * 0.1,
            children: <Widget>[
              IconButton(icon:
                  Stack(
                      children: <Widget>[
                        Icon(Icons.home),
                        Positioned(  // draw a red marble
                          top: 0.0,
                          right: 0.0,
                          child: Icon(Icons.brightness_1, size: 8.0,
                            color: Colors.redAccent),
                        )
                      ]
                  ),
                  onPressed: () {
                    print('Home');
                    toggleMenu();
                  }),
              IconButton(icon: Icon(Icons.archive), onPressed: () {
                print('Completed tasks');
                toggleMenu();
              }),
              IconButton(icon: Icon(Icons.reply_all), onPressed: () {
                toggleMenu();
                print('Earlier tasks');
              })
            ]
        ),
      ),
    );
  }
}