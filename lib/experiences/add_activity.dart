//import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:async';


class AddActivityState extends State<AddActivityPage>{

  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
//  File _eventImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateHeader(context),
      body: Container(
              child: SingleChildScrollView(
                child: generateForm(),
              )
          )
    );
  }

  Widget generateForm(){
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
//            SizedBox(height: 25.0),
//            RaisedButton(
//              onPressed: _optionsDialogBox,
//              child: Icon(Icons.add_a_photo),
//            ),
            SizedBox(height: 25.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Venue'),
            ),
            SizedBox(height: 25.0),
            Text(selectedDate != null ? "Event Start Date: "
                + "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}"
                : ""),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text("Select Start Date"),
            ),
            SizedBox(height: 25.0),
            Text(selectedEndDate != null ? "Event End Date: "
                + "${selectedEndDate.year.toString()}-${selectedEndDate.month.toString().padLeft(2,'0')}-${selectedEndDate.day.toString().padLeft(2,'0')}"
                : ""),
            RaisedButton(
              onPressed: () => _selectEndDate(context),
              child: Text("Select End Date"),
            ),
            SizedBox(height: 25.0),
            Text("Event Start Time: ${selectedStartTime}"),
            RaisedButton(
              onPressed: () => _selectStartTime(context),
              child: Text("Start time of Event"),
            ),
            SizedBox(height: 25.0),
            Text("Event End Time: ${selectedEndTime}"),
            RaisedButton(
              onPressed: () => _selectEndTime(context),
              child: Text("Start time of Event"),
            ),
            SizedBox(height: 25.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
             RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {

                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                },
              child: Text('Submit'),
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedEndDate)
      setState(() {
        selectedEndDate = picked;
      });
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedStartTime, builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      );});

    if (picked_s != null && picked_s != selectedStartTime )
      setState(() {
        selectedStartTime = picked_s;
      });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedEndTime, builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      );});

    if (picked_s != null && picked_s != selectedEndTime )
      setState(() {
        selectedEndTime = picked_s;
      });
  }


//  Future<void> _optionsDialogBox() {
//    return showDialog(context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            content: SingleChildScrollView(
//              child: ListBody(
//                children: <Widget>[
//                  GestureDetector(
//                    child: Text('Take a picture'),
//                    onTap: openCamera,
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                  ),
//                  GestureDetector(
//                    child: Text('Select from gallery'),
//                    onTap: openGallery,
//                  ),
//                ],
//              ),
//            ),
//          );
//        });
//  }
//
//  Future openCamera() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//
//    setState(() {
//      _eventImage = image;
//    });
//  }
//
//  Future openGallery() async {
//    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    setState(() {
//      _eventImage = image;
//    });
//  }

  String validate(String value){
      if (value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
  }
}

class AddActivityPage extends StatefulWidget {
    AddActivityState createState() => AddActivityState();
}

