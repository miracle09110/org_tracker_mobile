import 'package:flutter/material.dart';
import '../../models/Member.dart';

class MemberConfirmationDialog extends StatelessWidget {

  final Member memberForm;
  final Function submit;


  MemberConfirmationDialog({
    @required this.memberForm,
    @required this.submit,
  });


  @override
  Widget build(BuildContext context) {

    return SimpleDialog (
        title: Center(
          child: Text ("Confirm",
            style: TextStyle(fontSize: 25.0)
        ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
        children: <Widget>[
          Row (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton (
                color: Colors.black12,
                child: new Text("No"),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0)),
                onPressed: () {
                  Navigator.pop (context);
                },
              ),
              FlatButton (
                color: Theme.of(context).primaryColor,
                child: Text ("Yes",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0)),
                onPressed: () {
                  submit ({
                    'first_name': this.memberForm.name.firstName,
                    'last_name': this.memberForm.name.lastName,
                    'middle_initial': this.memberForm.name
                        .middleInitial,
                    'nickname': this.memberForm.name.nickname,
                    'email': this.memberForm.contactInfo.email,
                    'phone_number': this.memberForm.contactInfo
                        .mobile,
                    'job_title': this.memberForm.profession.jobTitle,
                    'employer': this.memberForm.profession.employer,
                    'field': this.memberForm.profession.field,
                    'batch': this.memberForm.batch,
                    'status': this.memberForm.status,
                    'cluster_id': this.memberForm.clusterId,
                    'date_of_birth': this.memberForm.dob
                  });
                },
              ),
            ],
          )
        ]
    );
  }
}