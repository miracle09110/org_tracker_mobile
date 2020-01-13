import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';


String emptyCheck(value){
  if (value.isEmpty) {
    return '*Required';
  }
  return null;
}


String phoneValidator(String value) {
  Pattern pattern =
      r"^(?:[+0]9)?[0-9]{9}$";
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return '*Tamang number po sana';
  else
    return null;
}

String emailValidator(value){
  if(!EmailValidator.validate(value))
    return '*Tamang email po sana';
  else
    return null;
}

String batchValidator(value){
  Pattern pattern =
      r"^[0-9]{4}$";
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return '*Tamang batch po sana';
  else
    return null;
}

String dateValidator(value){
  Pattern pattern =
      r"^(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$";
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return '*Tamang petsa po sana';
  else
    return null;
}