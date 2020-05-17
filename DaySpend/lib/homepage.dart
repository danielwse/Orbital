import 'package:flutter/material.dart';
//import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:DaySpend/constants.dart";
import 'package:DaySpend/piechart/piechart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/arrowbutton.dart';
import 'config/colors.dart';
import 'config/size.dart';
import 'config/strings.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea( 
        child: Scaffold(
        /*
      appBar: AppBar( 
        backgroundColor: Colors.black,
        title: Text("DaySpend",
        style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),*/
        body: Column(
          children: <Widget>[
        //    SizedBox(height: 30,
        //    child: Container(color: AppColors.primaryWhite)),
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                height: 320,
                width: double.infinity,
                color: Colors.white,
                child: Container(
                  alignment: Alignment(-0.9, -0.80),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.settings,
                            size: 30),
                          Icon(Icons.notifications,
                          size: 30),
                          Icon(Icons.assessment,
                          size: 30)
                        ],),
                      Center(
                        heightFactor: 1.8,
                        child: Text("THIS WEEK'S BUDGET",
                      style: GoogleFonts.playfairDisplaySC(
                          textStyle: TextStyle(color: Colors.black,
                          fontSize: 25)),
                    )),
                      SizedBox(
                        width: 300,
                        child:
                        Column(
                          children: <Widget>[
                            Text("Entertainment",
                            ),
                            RoundedProgressBar(
                         height: 20,
                         style: RoundedProgressBarStyle( 
                           borderWidth: 0,
                           widthShadow: 0),
                           margin: EdgeInsets.symmetric(vertical: 10),
                           borderRadius: BorderRadius.circular(24),
                         )
                          ]))
                    ])
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment(-0.9, -1),
                width: double.infinity,
                child: Text("Planner",
                    style: GoogleFonts.playfairDisplaySC(fontSize: 25.0)),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class ExpensesWidget extends StatefulWidget {
   @override
  _ExpensesWidgetState createState() => _ExpensesWidgetState();
}

class _ExpensesWidgetState extends State<ExpensesWidget> {
  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    double fontSize(double size) {
      return size * width / 414;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: height / 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: width / 20),
                  child: Text(
                    "Monthly Expenses",
                    style: GoogleFonts.playfairDisplaySC( 
                      textStyle: TextStyle(
                      fontSize: fontSize(24)),
              ))),
              Container(
                width: width / 3.5,
                margin: EdgeInsets.only(right: width / 30),
                child: Row(
                  children: <Widget>[
                    /*ArrowButton(
                      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: fontSize(17),
                      ),
                    ),*/
                    Padding(padding: EdgeInsets.only(left: width / 50)),
                    ArrowButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: fontSize(40),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: category.map((data) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: AppColors
                                      .pieColors[category.indexOf(data)],
                                  shape: BoxShape.circle),
                            ),
                            Text(
                              data['name'],
                              style: TextStyle(
                                fontSize: fontSize(15),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: PieChart(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    //path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}*/

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
