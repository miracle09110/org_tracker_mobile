import 'package:flutter/material.dart';
import 'register.dart';
import 'activities.dart';


class _HomeState extends State<HomePage>{

  int _currentIndex = 0;
  final List<Widget> _children = [
    Activities(),
    Register()
  ];

  @override
  Widget build(BuildContext context) {

    onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Acitivties')
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add_box),
            title: new Text('Add Info')
          )
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
   _HomeState createState() => _HomeState();
}