import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:org_tracker/integrations/graphql/queries/read_clusters.dart';

class ClusterDropDown extends StatefulWidget{

  final Function(String) onChange;

  ClusterDropDown({
    @required this.onChange
  });

  _ClusterState createState()=> _ClusterState(
    onChoose: (value){
      onChange(value);
    }
  );
}

class _ClusterState extends State<ClusterDropDown>{
   final Function(String) onChoose;

    _ClusterState({
      @required this.onChoose
    });


    var _selectedCluster;
    List<dynamic> _clusters;

    @override
    Widget build(BuildContext context) {

      return Query(
          options: QueryOptions(
            document: clustersQuery,
          ),
          builder: (QueryResult result, {FetchMore fetchMore, VoidCallback refetch}){
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading) {
              return Center(child: LinearProgressIndicator());
            }

            _clusters == null? _clusters = result.data['clusters'] : _clusters;


            return Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    DropdownButton<dynamic>(
                        hint: Text('Choose Cluster'),
                        onChanged: (cluster){
                          setState(() {
                            //LOL, why is state not changing
                            _selectedCluster = cluster;
                            this.onChoose(_selectedCluster['_id']);
                          });
                        },
                        value: _selectedCluster,
                        items: _clusters.map((cluster){
                          return DropdownMenuItem(
                              child: Text(cluster['name']),
                              value: cluster
                          );
                        }).toList()
                    ),
                  ],
                )
            );
          });
    }
}
