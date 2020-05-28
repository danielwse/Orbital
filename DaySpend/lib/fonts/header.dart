import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header({@required this.text, @required this.size, this.italic});
  final double size;
  final String text;
  final bool italic;
  @override
  Widget build(BuildContext context) {
    FontStyle key = FontStyle.normal;
    if (italic) {
      key = FontStyle.italic;
    }
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w300,
          fontStyle: key,
          color: Colors.black),
    );
  }
}
