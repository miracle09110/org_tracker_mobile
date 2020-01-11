import 'package:flutter/material.dart';
import 'package:org_tracker/integrations/graphql/graphql.dart';
import 'experiences/login.dart';
import 'experiences/signup.dart';
import 'pages/home.dart';
import 'experiences/login_register.dart';
import 'experiences/add_activity.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: getClient(),
      child: CacheProvider(
        child: MaterialApp(
            title: "SCAP Org Tracker",
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            home: HomePage(),
        ),
      )
    );
  }
}
