import 'package:DaySpend/fonts/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:nice_button/NiceButton.dart';

class RoutineButton extends StatelessWidget {

  final Function updateTime;
  final DateTime originalTime;

  RoutineButton({this.updateTime, this.originalTime});
  @override
  Widget build(BuildContext context) {
    DateTime newDateTime = originalTime.add(Duration(days: 7));
    String displayText = "This task will be set to the next \n\n" + DateFormat('EEEE').format(newDateTime).toString() + ", at " + DateFormat('Hm').format(newDateTime).toString();

    return IconSlideAction(
      caption: 'Reset', color: Colors.teal[100], icon: Icons.replay,
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: Color(0xff757575),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 50),
                        child: Text(
                          displayText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: NiceButton(
                          width: 100,
                          text: "Confirm",
                          elevation: 8.0,
                          radius: 52.0,
                          fontSize: 16,
                          textColor: Colors.white,
                          background: Colors.teal,
                          onPressed: () {
                            updateTime(newDateTime);
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}