import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../customwidgets/CustomTextField.dart';
import '../integrations/graphql/mutations/activity.dart';
import '../util/validator_util.dart';
import '../models/Activity.dart';
import '../enum/form_state.dart';

class AddActivityState extends State<AddActivityPage>{

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ACTIVITY_FORM_STATE _formState = ACTIVITY_FORM_STATE.OPEN;
  Activity _activity = new Activity();
  String _startText = "";
  String _endText = "";
  File _eventImage;

  void reset(){
    setState(() {
      _activity = new Activity();
      _startText = "";
      _endText = "";
      _eventImage = null;
    });
  }

  void setFormState(ACTIVITY_FORM_STATE state){
    setState(() {
      _formState = state;
    });
  }

  Future getImage() async {

    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            )
    );

    var image = await ImagePicker.pickImage(source: imageSource);

    setState(() {
      if(image != null){
        _eventImage = image;
        _activity.image = base64Encode(image.readAsBytesSync());
      }
    });
  }

  void showResultDialog(text){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog (

            title:
            Center(
              child: Text(text) ,
            ),
            actions: <Widget>[

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton (
                      textColor: Theme.of(context).primaryColor,
                      child: Text("OK"),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0)),
                      onPressed: () {
                        Navigator.pop (context);
                      },
                    ),
                  ],
                ) ,

            ],
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateHeader(context),
      body: Container(
              child: SingleChildScrollView(
                child: Mutation(
                  options: MutationOptions(
                    documentNode: gql(addActivityQuery),
                    onCompleted: (dynamic value){

                      if(_formState != ACTIVITY_FORM_STATE.FAIL) {
                        //reset();
                        setFormState(ACTIVITY_FORM_STATE.OPEN);
                        showResultDialog('Activity Added!');
                      }
                    },
                    onError:  (dynamic value){
                      setFormState(ACTIVITY_FORM_STATE.FAIL);
                      showResultDialog('Pasensya.Please check WIFI and retry');
                    }
                  ),
                  builder: (RunMutation addActivity, QueryResult addedActivity){

                    switch(_formState){
                      case ACTIVITY_FORM_STATE.LOADING:
                        return Container(
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
                      case ACTIVITY_FORM_STATE.FAIL:
                      case ACTIVITY_FORM_STATE.OPEN:
                      default:
                        return generateForm(addActivity);
                    }

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
                        'Start: $_startText',
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
                        'End: $_endText',
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
                      Text('Promotional Image (Ideally Landscape)',
                        style: TextStyle(fontSize: 15),
                      ),
                      FlatButton(
                        child: _eventImage == null ? Icon(Icons.image,
                          size: 150,
                        ) : Image.file(_eventImage),
                        onPressed: getImage,
                        autofocus: true,
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
                  autofocus: true,
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
                          setFormState(ACTIVITY_FORM_STATE.LOADING);
                          print(_activity.image.runtimeType);
                          print("${_activity.image}");
                          addActivity({
                            'event_name' : _activity.eventName,
                            'venue' : _activity.venue,
                            'start_date' : _activity.startDate,
                            'end_date': _activity.endDate,
                            'start_time': _activity.startTime,
                            'end_time': _activity.endTime,
                            'image' : _activity.image,
                            'description' :  _activity.description
                          });

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
      String date = splitDateTime[0];
      String time = splitDateTime[1].substring(0,splitDateTime[1].lastIndexOf(":"));
      setState(() {
        _activity.startDate = date;
        _activity.startTime = time;
        _startText = date + " " + time;
      });
  }

  void setEndDateAndTime(value){
    List<String> splitDateTime = value.toString().split(" ");
    String date = splitDateTime[0];
    String time = splitDateTime[1].substring(0,splitDateTime[1].lastIndexOf(":"));
    setState(() {
      _activity.endDate = date;
      _activity.endTime= time;
      _endText = date + " " + time;
    });
  }
}

class AddActivityPage extends StatefulWidget {
    AddActivityState createState() => AddActivityState();
}

