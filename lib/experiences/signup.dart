import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:org_tracker/integrations/graphql/mutations/add_member.dart';
import '../customwidgets/IndustryDropDown.dart';
import '../customwidgets/ClusterDropDown.dart';
import '../customwidgets/CircularProgressIndicatorWithText.dart';
import '../models/Member.dart';

enum Answers{YES, NO}

class _SignUpState extends State<SignUpPage>{

    List<GlobalKey<FormState>> _formKeys =
    [
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
      GlobalKey<FormState>()
    ];
    int currentStep = 0;
    bool submitting = false;
    StepperType stepperType = StepperType.vertical;
    DateTime dob = DateTime.now();
    Member _member =  new Member();


    String validator(value){
      if (value.isEmpty) {
        return '*Required';
      }
      return null;
    }

    String _phoneNumberValidator(String value) {
      Pattern pattern =
          r"^(?:[+0]9)?[0-9]{10}$)";
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Phone Number';
      else
        return null;
    }

     Future<Null> _selectDate(BuildContext context) async {
       final DateTime picked = await showDatePicker(
           context: context,
           initialDate: DateTime(2000,1),
           firstDate: DateTime(1950, 1),
           lastDate: DateTime.now());
       if (picked != null && picked != dob)
         setState(() {
           this._member.dob = picked.toString();
           dob = picked;
         });
     }


    void showUnfinisedDialog(BuildContext context){
      Widget cancelButton = FlatButton(
        child: Text("OK"),
        onPressed:  () {
          Navigator.of(context).pop();
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Warning"),
        content: Text("Please fill out all required sections to register a member"),
        actions: [
          cancelButton
        ],
      );


      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    void _showConfirmationDialog (BuildContext context)  {

     showDialog(
          context: context,
          builder: (BuildContext context) {
            return Mutation(
                options: MutationOptions(
                  document: addMemberQuery,
                ),
                builder: (
                    RunMutation runMutation,
                    QueryResult result,
                    )
                {
                  if(result.loading){
                    return SimpleDialog(
                        title: Text("Adding..."),
                        children: <Widget>[
                          LinearProgressIndicator()
                        ]
                    );
                  }

                  if(result.hasException){
                    print(result.exception.toString());
                  }

                  return SimpleDialog(
                      title: Text("Confirm"),
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SimpleDialogOption(
                              child: Text("Yes"),
                              onPressed: () =>{
                                runMutation({
                                  'first_name'      : this._member.name.firstName,
                                  'last_name'       : this._member.name.lastName,
                                  'middle_initial'  : this._member.name.middleInitial,
                                  'nickname'        : this._member.name.nickname,
                                  'email'           : this._member.contactInfo.email,
                                  'phone_number'    : this._member.contactInfo.mobile,
                                  'job_title'       : this._member.profession.jobTitle,
                                  'employer'        : this._member.profession.employer,
                                  'field'           : this._member.profession.field,
                                  'batch'           : this._member.batch,
                                  'status'          : this._member.status,
                                  'cluster_id'      : this._member.clusterId,
                                  'date_of_birth'   : this._member.dob
                                })
                              },
                            ),
                            SimpleDialogOption(
                              child: new Text("No"),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            )
                          ],
                        )
                      ]
                  );
                },
            );
          },
        );
    }

     @override
    Widget build(BuildContext context) {

      isClicked(int step){
        return currentStep == step;
      }

      isDone(int step){
        return currentStep >= step;
      }

      List<Step> steps = [
      Step(
        title: const Text('Info'),
        isActive: isDone(0),
        state:  isClicked(0) ? StepState.editing :
          isDone(0)? StepState.complete: StepState.indexed,
        content: Form(
            key: _formKeys[0],
            child: Column(
              children: <Widget>[
                Text('Personal Info'),
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: validator,
                  onSaved: (String value){
                    this._member.name.firstName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Surname'),
                  validator: validator,
                  onSaved: (String value){
                    this._member.name.lastName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Middle Initial'),
                  validator: validator,
                  onSaved: (String value){
                    this._member.name.middleInitial = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nickname'),
                  onSaved: (String value){
                    this._member.name.nickname = value;
                  },
                ),
                SizedBox(height: 25.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: <Widget>[
                      Text(dob != null ? "Date of Birth: "
                          + "${dob.year.toString()}-${dob.month.toString().padLeft(2,'0')}-${dob.day.toString().padLeft(2,'0')}"
                          : "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            )
                          ,
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text("Change Date of Birth"),
                      ),
                    ],
                  )
                )
              ],
            ),
        )
      ),
      Step(
        isActive: isDone(1),
        state:  isClicked(1) ? StepState.editing :
          isDone(1)? StepState.complete: StepState.indexed,
        title: const Text('Contact'),
        content: Form(
          key: _formKeys[1],
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile Number'),
                validator: validator,
                keyboardType: TextInputType.phone,
                onSaved: (String value){
                  this._member.contactInfo.mobile = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: validator,
                onSaved: (String value){
                  this._member.contactInfo.email = value;
                },
              ),
            ],
          ),
        )
      ),
      Step(
        isActive: isDone(2),
        state:  isClicked(2) ? StepState.editing :
        isDone(2)? StepState.complete: StepState.indexed,
        title: const Text('Affiliation'),
        content: Form(
          key: _formKeys[2],
          child: Column(
            children: <Widget>[
              ClusterDropDown(
                onChange: (value){
                  print(value);
                  this._member.clusterId = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Year Graduated'),
                validator: validator,
                onSaved: (String value){
                  this._member.batch = value;
                },
              )
            ],
          ),
        )
      ),
      Step(
        isActive: isDone(3),
        state:  isClicked(3) ? StepState.editing :
          isDone(3)? StepState.complete: StepState.indexed,
        title: const Text('Profession'),
        content: Form(
          key: _formKeys[3],
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: validator,
                onSaved: (String value){
                  this._member.profession.jobTitle = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Employer'),
                validator: validator,
                onSaved: (String value){
                  this._member.profession.employer = value;
                },
              ),
              SizedBox(height: 25.0),
              IndustryDropDown(
                onChange: (value){
                  this._member.profession.field = value;
                },
              )
            ],
          ),
        )
      ),
    ];

      void goTo(int step){
        setState(()=> currentStep = step);
      }

      void saveAndMoveToNext(){
        _formKeys[currentStep].currentState.save();
        goTo(currentStep +1);
      }


      void next(){
        if (_formKeys[currentStep].currentState.validate()) {
          currentStep + 1 != steps.length ?
          saveAndMoveToNext()
              : _showConfirmationDialog(context);
        }
      }

      void cancel(){
        if(currentStep > 0){
          goTo(currentStep - 1);
        }
      }

    return new Scaffold(
      appBar: AppBar(
        title: Text('Register an eSCAN'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
           Expanded(
            child: Stepper(
              steps: steps,
              type: stepperType,
              currentStep: currentStep,
              onStepContinue: next,
              onStepTapped: (step) => goTo(step),
              onStepCancel: cancel,
            ),
          )
        ],
      ),
    );
  }
}


class SignUpPage extends StatefulWidget{
  _SignUpState createState() => _SignUpState();
}