import 'package:flutter/material.dart';


class GenericErrorDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Ooops"),
        content: Text("May mali na nangyari! Pwede po pakiulit?"),
        actions: [
          FlatButton(
            child: Text("OK"),
            color: Theme.of(context).primaryColor,
            onPressed:  () {
              Navigator.of(context).pop();
            },
          )
        ],
    );
  }
}