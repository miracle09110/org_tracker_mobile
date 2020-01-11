import 'package:flutter/material.dart';


class CircularProgressIndicatorWithText extends StatelessWidget{

  CircularProgressIndicatorWithText({
    @required this.text
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(),
          Text(text)
        ],
      ) ,
    );
  }
}