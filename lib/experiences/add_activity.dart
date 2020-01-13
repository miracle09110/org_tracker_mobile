import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../customwidgets/CustomTextField.dart';
import '../util/validator_util.dart';
import '../models/Activity.dart';

class AddActivityState extends State<AddActivityPage>{

  final _formKey = GlobalKey<FormState>();
  Activity _activity = new Activity();
  String _startDate ="";
  String _endDate ="";
  String _startTime ="";
  String _endTime ="";
//  File _eventImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateHeader(context),
      body: Container(
              child: SingleChildScrollView(
                child: Mutation(
                  options: MutationOptions(
                    documentNode: gql(""),
                    onCompleted: (dynamic value){
                      _formKey.currentState.reset();
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(
                            content: Text('Activity Successfully Added!')
                         )
                      );
                    },
                    onError:  (dynamic value){
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Something went wrong!')
                          )
                      );
                    }
                  ),
                  builder: (RunMutation addActivity, QueryResult addedActivity){


                    if(addedActivity.loading){
                      return
                      Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height/ 4
                        ),
                        alignment: Alignment.center,
                        child:  Center(
                          child: Column(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Text('Adding your Activity...')
                            ],
                          ) ,
                        ),
                      );

                    }

                    return generateForm(addActivity);
                  },
                )
              )
          )
    );
  }

  Widget generateForm(addActivity){
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25.0),
            CustomTextField(
              icon: Icon(Icons.event),
              hint: "Event Name",
              fontSize: 15,
              validator: emptyCheck,
              onSaved: (value){
                this._activity.eventName = value;
              },
            ),
            SizedBox(height: 25.0),
            Center(
                child:ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width - 100 ,
                  height: 30,
                  child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0)),
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1970, 1, 1),
                            maxTime: DateTime.now(),
                            onChanged: (date) {
                              print('Start Changed $date');
                            }, onConfirm: (date) {
                              setStartDateAndTime(date);
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.en
                        );
                      },
                      child: Text(
                        'Start: $_startDate $_startTime',
                        style: TextStyle(color: Colors.white),
                      )
                  ),
                )
            ),
            Center(
                child:ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width - 100 ,
                  height: 30,
                  child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0)),
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1970, 1, 1),
                            maxTime: DateTime.now(),
                            onChanged: (date) {
                              print('End Changed $date');
                            }, onConfirm: (date) {
                              setEndDateAndTime(date);
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.en
                        );
                      },
                      child: Text(
                        'End: $_endDate $_endTime',
                        style: TextStyle(color: Colors.white),
                      )
                  ),
                )
            ),
            SizedBox(height: 10.0),
            CustomTextField(
              icon: Icon(Icons.place),
              hint: "Venue",
              fontSize: 15,
              validator: emptyCheck,
              onSaved: (value){
                this._activity.venue= value;
              },
            ),
            Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0) //
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Promotional Image',
                        style: TextStyle(fontSize: 15),
                      ),
                      FlatButton(
                        child: Icon(Icons.image,
                          size: 150,
                        ),
                      )
                    ],
                  ),
                )
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20
              ),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.all(
                    Radius.circular(30.0) //
                ),
              ),
              child: SizedBox(
                height: 180,
                child: TextFormField(
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ' Description...',
                  ),
                  onSaved: (description){
                    this._activity.description = description;
                  },
                  validator: emptyCheck,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: 20,
              ),
              child:  Center(
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width - 100 ,
                    height: 50,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0)
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          addActivity();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  )
              ),
            )

          ],
        ),
    );
  }

  Widget generateHeader(BuildContext context){
    return AppBar(
      title: Text('Add an SCA Activity'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void setStartDateAndTime(value){
      List<String> splitDateTime = value.toString().split(" ");
      setState(() {
        _startDate = splitDateTime[0];
      });

      setState(() {
        _startTime = splitDateTime[1].substring(0,splitDateTime[1].lastIndexOf(":"));
      });
  }

  void setEndDateAndTime(value){
    List<String> splitDateTime = value.toString().split(" ");
    setState(() {
      this._endDate = splitDateTime[0];
    });

    setState(() {
      this._endTime = splitDateTime[1].substring(0,splitDateTime[1].lastIndexOf(":"));
    });
  }
}

class AddActivityPage extends StatefulWidget {
    AddActivityState createState() => AddActivityState();
}

