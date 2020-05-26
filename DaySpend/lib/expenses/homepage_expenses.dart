import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';

class HomePageExpenses extends StatelessWidget {
  const HomePageExpenses({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        height: 350,
                        width: double.infinity,
                        color: Colors.white,
                        child: Container(
                            child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "DaySpend",
                                style: TextStyle(
                                    fontFamily: 'HelveticaNeue Medium',
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.settings, size: 25),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.notifications, size: 25),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.assessment, size: 25))
                            ],
                          ),
                          Center(
                              heightFactor: 1,
                              child: Text(
                                "THIS WEEK'S BUDGET",
                                style: TextStyle(
                                    fontFamily: 'HelveticaNeue Medium',
                                    color: Colors.black,
                                    fontSize: 25),
                              )),
                          Spacer(),
                          SizedBox(
                              width: 300,
                              child: Row(children: <Widget>[
                                Text(
                                  "Entertainment",
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeue Light',
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text("\$300 left")
                              ])),
                          SizedBox(
                              width: 300,
                              child: RoundedProgressBar(
                                height: 12,
                                theme: RoundedProgressBarTheme.blue,
                                style: RoundedProgressBarStyle(
                                    borderWidth: 0, widthShadow: 0),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                borderRadius: BorderRadius.circular(24),
                              )),
                          SizedBox(
                              width: 300,
                              child: Row(children: <Widget>[
                                Text(
                                  "Eating Out",
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeue Light',
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text("\$20 left")
                              ])),
                          SizedBox(
                              width: 300,
                              child: RoundedProgressBar(
                                height: 12,
                                theme: RoundedProgressBarTheme.red,
                                style: RoundedProgressBarStyle(
                                    borderWidth: 0, widthShadow: 0),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                borderRadius: BorderRadius.circular(24),
                              )),
                          SizedBox(
                              width: 300,
                              child: Row(children: <Widget>[
                                Text(
                                  "Shopping",
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeue Light',
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text("\$90 left")
                              ])),
                          SizedBox(
                              width: 300,
                              child: RoundedProgressBar(
                                milliseconds: 1000,
                                height: 12,
                                theme: RoundedProgressBarTheme.midnight,
                                style: RoundedProgressBarStyle(
                                    borderWidth: 0, widthShadow: 0),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                borderRadius: BorderRadius.circular(24),
                              )),
                          SizedBox(
                              width: 300,
                              child: Row(children: <Widget>[
                                Text(
                                  "Utilities",
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeue Light',
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text("\$100 left")
                              ])),
                          SizedBox(
                              width: 300,
                              child: RoundedProgressBar(
                                height: 12,
                                theme: RoundedProgressBarTheme.green,
                                style: RoundedProgressBarStyle(
                                    borderWidth: 0, widthShadow: 0),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                borderRadius: BorderRadius.circular(24),
                              ))
                        ])),
                      ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 20;
    while (curXPos < size.width) {
      curXPos += increment;
      path.arcToPoint(Offset(curXPos, curYPos), radius: Radius.circular(5));
    }
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
