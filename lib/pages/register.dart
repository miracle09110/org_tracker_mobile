import 'package:flutter/material.dart';
import '../experiences/add_activity.dart';
import '../experiences/signup.dart';

class Register extends StatelessWidget{

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
       child: Center(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               SizedBox(
                 height: 155.0,
                 child: Image.asset(
                   "assets/logo.png",
                   fit: BoxFit.contain,
                 ),
               ),
               SizedBox(height: 45.0),
               addMemberButton(context),
               SizedBox(height: 25.0),
               addActivityButton(context)
             ],
           )
       )
    );
  }

  Widget addMemberButton(BuildContext context){
    return ButtonTheme(
        minWidth: MediaQuery.of(context).size.width - 30.0 ,
        child: RaisedButton(
          onPressed: _addMember,
          textColor: Colors.white,
          hoverColor: Colors.indigoAccent,
          padding: EdgeInsets.all(10),
          child: Text('Add Member',
              style: TextStyle(fontSize: 20, )
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        )
    );
  }

  Widget addActivityButton(BuildContext context){
    return ButtonTheme(
        minWidth: MediaQuery.of(context).size.width - 30.0 ,
        child: RaisedButton(
          onPressed: _addActivity,
          textColor: Colors.white,
          hoverColor: Colors.indigoAccent,
          padding: EdgeInsets.all(10),
          child: Text('Add Activity',
              style: TextStyle(fontSize: 20, )
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        )
    );
  }

  void _addMember(){
    Navigator.of(_context).push(
        MaterialPageRoute<void>(
          builder: (context) => SignUpPage(),
        )
    );
  }

  void _addActivity(){
    Navigator.of(_context).push(
      MaterialPageRoute<void>(
        builder: (context) => AddActivityPage(),
      )
    );
  }

}

