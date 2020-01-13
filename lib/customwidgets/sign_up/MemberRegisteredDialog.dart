import 'package:flutter/material.dart';
import '../../models/Member.dart';


class MemberRegisteredDialog extends StatelessWidget{

  final Member memberInfo;
  final Function onConfirm;
  MemberRegisteredDialog({
    @required this.memberInfo,
    @required this.onConfirm
  });

  @override
  Widget build(BuildContext context) {

    return SimpleDialog(
      title: Center(
          child:Text('Congrats!')
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20.0)
      ),
      children: <Widget>[
        Container(
            child: Center(
                child: Column(
                  children: <Widget>[
                    Text('Maraming salamat kaibigan'),
                    Text( 'You have successfully registered,'),
                    Text( memberInfo.name.firstName.toUpperCase(),
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
            )
        ),
        SizedBox(height: 15.0),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text ("OK"),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0)
                ),
                onPressed: onConfirm,
              )
            ],
        )

      ],
    );
  }
}