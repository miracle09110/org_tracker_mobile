import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';


ValueNotifier<GraphQLClient> getClient(){
  final HttpLink httpLink = HttpLink(uri: "http://ec2-18-139-217-149.ap-southeast-1.compute.amazonaws.com:1973/graphql");

  return ValueNotifier(
      GraphQLClient(
          link: httpLink,
          cache:  NormalizedInMemoryCache(
            dataIdFromObject: typenameDataIdFromObject,
          ),
      )
  );
}


