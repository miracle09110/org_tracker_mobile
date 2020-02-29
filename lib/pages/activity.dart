import 'package:flutter/material.dart';


class ActivityPage extends StatelessWidget {
  
  const ActivityPage({
    Key key, 
    this.eventName, 
    this.venue, 
    this.startDate, 
    this.endDate,
    this.startTime,
    this.endTime,
    this.image,
    this.description
    }) : super(key: key);

  final String eventName;
  final String venue;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final Image image;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text(eventName),
         leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: <Widget>[
          imageBox(),
          descriptionBox(),
          timeAndVenueBox()
        ],
      )
    );
  }

  Widget timeAndVenueBox(){
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          locationText(),
          SizedBox(height: 10),
          startText(),
          SizedBox(width: 10),
          endText()
      ],),
    );
  }


  Widget imageBox(){
    return  FittedBox (
              child:  image
            );
  }

  Widget descriptionBox(){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0
          )
        )
      ),
      padding: const EdgeInsets.all(10.0),
      child:  Expanded(
                  child: Text(description)
            ),
          );
  }

  Widget locationText(){
    return  Row(
            children: <Widget>[
              Icon(Icons.location_on),
              SizedBox(width: 5),
              Expanded(child: Text("Venue: ${venue}"))
            ]
          );
  }

  Widget startText(){
    return  Row(
            children: <Widget>[
              Icon(Icons.access_time),
              SizedBox(width: 5),
              Expanded(child: Text("From: ${startDate} at ${startTime}"))
            ]
          );
  }

   Widget endText(){
    return  Row(
            children: <Widget>[
              Icon(Icons.access_time),
              SizedBox(width: 5),
              Expanded(child: Text("To: ${endDate} at ${endTime}"))
            ]
          );
  }




}