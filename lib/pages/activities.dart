import 'dart:io' as Io;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:org_tracker/integrations/graphql/queries/read_activities.dart';

class ActivityState extends State<Activities>{


  Widget _activityListView(BuildContext context){

    return Query(
      options: QueryOptions(
          document: activityQuery,
          pollInterval: 60000
      ),
      builder: (QueryResult result, {FetchMore fetchMore, VoidCallback refetch}){
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.loading) {
          return Center(child: CircularProgressIndicator());
        }

        List<dynamic> activities = result.data['activities'];

        print(activities.length);
        if (activities.length == 0){
          return Text('No Data lol');
        }

        return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context,index){
              return Card (
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Padding (
                  padding: EdgeInsets.all (0),
                  child: Column (
                    children: <Widget>[
                      FittedBox (
                        child:  Image.memory(base64.decode(activities[index]['image_base_64']),
                          fit: BoxFit.fitWidth,
                          width: 500.00,
                          height: 300.00,
                        ),
                      ),

                      Container (
                        height: 50.0,
                        child: ListTile (
                          title: Text (activities[index]['event_name']),
                          trailing: Text (
                            activities[index]['start_date'],
                            style: TextStyle (color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder (
                  borderRadius: BorderRadius.circular (10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all (10),
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _activityListView(context);
  }
}
class Activities extends StatefulWidget{
  ActivityState createState() => ActivityState();
}

