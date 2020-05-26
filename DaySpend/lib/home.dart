import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//*Change color fo container once done*

class Home extends StatelessWidget {
  // base properties insert here <var>
  @override
  Widget build(BuildContext context) {
    // hot reload runs build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'DaySpend',
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.open_in_new,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  height: 200,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.tealAccent,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'THIS WEEK\'S BUDGET',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.blueGrey,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  height: 200,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.tealAccent,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'HAPPENING TODAY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.blueGrey,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
