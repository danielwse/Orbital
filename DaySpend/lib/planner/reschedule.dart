import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nice_button/NiceButton.dart';

class RescheduleButton extends StatelessWidget {

  final Function updateTime;

  RescheduleButton({this.updateTime});
  @override
  Widget build(BuildContext context) {
    DateTime newDateTime;
    DateTime currentTime = DateTime.now().add(Duration(minutes: 1));

    return IconSlideAction(
      caption: 'Schedule', color: Colors.redAccent[100], icon: Icons.replay,
      onTap: () {
        newDateTime = currentTime;
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
                            if (newDateTime.isBefore(DateTime.now())) {
                              updateTime(DateTime.now().add(Duration(minutes: 1)));
                              print("set time too close to current time");
                            } else {
                              updateTime(newDateTime);
                            }
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
