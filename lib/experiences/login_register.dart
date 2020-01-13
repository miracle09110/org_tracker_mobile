import 'package:flutter/material.dart';
import '../customwidgets/login/CustomTextField.dart';

class LoginRegisterState extends State<LoginRegisterPage>{
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    String _email;
    String _password;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _autoValidate = false;
    bool _loading = false;



    return Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomTextField(
                    onSaved: (input){
                      _email = input;
                    },
                    validator: emailValidator,
                    icon: Icon(Icons.email),
                    hint: "EMAIL"
                ),
                SizedBox(height: 25.0),
                CustomTextField(
                  icon: Icon(Icons.lock),
                  obsecure: true,
                  onSaved: (input) => _password = input,
                  validator: (input) => input.isEmpty ? "*Required" : null,
                  hint: "PASSWORD",
                ),
                SizedBox(height: 25.0),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: _loading == true
                      ? CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        primaryColor),
                  )
                      : Container(
                    child: filledButton(
                        "LOGIN",
                        Colors.white,
                        primaryColor,
                        primaryColor,
                        Colors.white,
                        _validateLoginInput),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}


String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) return '*Required';
  if (!regex.hasMatch(value))
    return '*Enter a valid email';
  else
    return null;
}

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterState createState() => LoginRegisterState();
}

Widget filledButton(String text, Color splashColor, Color highlightColor,
    Color fillColor, Color textColor, void function()) {
  return RaisedButton(
    highlightElevation: 0.0,
    splashColor: splashColor,
    highlightColor: highlightColor,
    elevation: 0.0,
    color: fillColor,
    shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0)),
    child: Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
    ),
    onPressed: () {
      function();
    },
  );
}

void _validateLoginInput(){

}