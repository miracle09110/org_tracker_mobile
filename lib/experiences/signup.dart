import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:org_tracker/integrations/graphql/mutations/add_member.dart';
import '../customwidgets/sign_up/IndustryDropDown.dart';
import '../customwidgets/sign_up/ClusterDropDown.dart';
import '../customwidgets/sign_up/MemberConfirmationDialog.dart';
import '../customwidgets/sign_up/MemberRegisteredDialog.dart';
import '../customwidgets/GenericErrorDialog.dart';
import '../models/Member.dart';
import '../enum/register_state.dart';
import '../util/validator_util.dart';




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
    bool registered = false;
    REGISTER_STATE registerState = REGISTER_STATE.OPEN;


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

    void goTo(int step){
      setState(()=> currentStep = step);
    }

    void resetForm(){
      for (var i =0; i<_formKeys.length; i++){
        _formKeys[i].currentState.reset();
      }

      goTo(0);
    }

    void switchFormState(REGISTER_STATE state){
      setState(() {
        this.registerState = state;
      });
    }

    void _submitForm (BuildContext context)  {

     showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Mutation(
                options: MutationOptions(
                  documentNode: gql(addMemberQuery),
                  onCompleted: (dynamic resultData){
                    switchFormState(REGISTER_STATE.SUCCESS);
                  },
                  onError: (dynamic errorData){
                    print(errorData.toString());
                    switchFormState(REGISTER_STATE.FAIL);
                  }
                ),
                builder: (
                    RunMutation runMutation,
                    QueryResult result,
                    ) {
                  if (result.loading) {
                    return SimpleDialog (
                        title: Text ("Adding..."),
                        children: <Widget>[
                          LinearProgressIndicator ()
                        ]
                    );
                  }

                  if (result.hasException) {
                    print (result.exception.toString ());
                  }

                  switch(registerState){
                    case REGISTER_STATE.SUCCESS:
                      return MemberRegisteredDialog(
                        memberInfo: _member,
                        onConfirm: (){
                            switchFormState(REGISTER_STATE.OPEN);
                            resetForm();
                            Navigator.of(context).pop();
                        },
                      );
                      break;
                    case REGISTER_STATE.FAIL:
                      return GenericErrorDialog();
                      break;
                    case REGISTER_STATE.OPEN:
                    default:
                      return MemberConfirmationDialog(
                        memberForm: _member,
                        submit: runMutation,
                      );
                  }

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
                  validator: emptyCheck,
                  onSaved: (String value){
                    this._member.name.firstName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Surname'),
                  validator: emptyCheck,
                  onSaved: (String value){
                    this._member.name.lastName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Middle Initial'),
                  validator: emptyCheck,
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
                validator: emptyCheck,
                keyboardType: TextInputType.phone,
                onSaved: (String value){
                  this._member.contactInfo.mobile = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: emptyCheck,
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
                validator: emptyCheck,
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
                validator: emptyCheck,
                onSaved: (String value){
                  this._member.profession.jobTitle = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Employer'),
                validator: emptyCheck,
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

      void transition(){
        currentStep + 1 != steps.length ?
        goTo(currentStep +1)
            : _submitForm(context);
      }

      void next(){
        if (_formKeys[currentStep].currentState.validate()) {
          _formKeys[currentStep].currentState.save();
          transition();
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