import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nice_button/NiceButton.dart';

class RescheduleButton extends StatelessWidget {

  final Function rescheduleCallback;
  final Color color;
  final Duration prevDuration;

  RescheduleButton({this.rescheduleCallback, this.color, this.prevDuration});
  @override
  Widget build(BuildContext context) {
    DateTime newDateTime;
    Duration newDuration;
    DateTime currentTime = DateTime.now().add(Duration(minutes: 1));

    return IconSlideAction(
      caption: 'Schedule', color: color, icon: Icons.replay,
      onTap: () {
        newDateTime = currentTime;
        newDuration = prevDuration;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Set duration of task:", style:
                            TextStyle(
                                fontSize: 18
                            ),)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: MediaQuery.of(context).copyWith().size.height / 4,
                        width: MediaQuery.of(context).copyWith().size.width / 1.5,
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hm,
                          initialTimerDuration: prevDuration,
                          onTimerDurationChanged: (Duration dur) {
                            newDuration = dur;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Choose a date:", style:
                              TextStyle(
                                fontSize: 18
                              ),)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: MediaQuery.of(context).copyWith().size.height / 4,
                        width: MediaQuery.of(context).copyWith().size.width / 1.5,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.dateAndTime,
                          initialDateTime: currentTime,
                          onDateTimeChanged: (DateTime dt) {
                            newDateTime = dt;
                          },
                          use24hFormat: true,
                          minuteInterval: 1,
                          minimumDate: currentTime,
                          maximumDate: currentTime.add(Duration(days: 6)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 25),
                        child: NiceButton(
                          width: 120,
                          text: "Confirm",
                          elevation: 8.0,
                          radius: 52.0,
                          fontSize: 16,
                          textColor: Colors.white,
                          background: Colors.teal,
                          onPressed: () {
                            if (newDateTime.isBefore(DateTime.now())) {
                              rescheduleCallback(DateTime.now().add(Duration(minutes: 1)), newDuration);
                              print("set time too close to current time");
                            } else {
                              rescheduleCallback(newDateTime, newDuration);
                            }
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
