import 'package:flutter/material.dart';
import 'Industries.dart';


class IndustryDropDown extends StatefulWidget{
  final Function(String) onChange;

  IndustryDropDown({
    @required this.onChange
  });

  _IndustryState createState() => _IndustryState(
    onChoose: (value){
      onChange(value);
    }
  );
}

class _IndustryState extends State<IndustryDropDown>{
  final Function(String) onChoose;

  _IndustryState({
    @required this.onChoose
  });

  String _selectedField;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButton(
                hint: Text('Field'),
                value: _selectedField,
                onChanged: (value){
                  setState(() {
                    _selectedField = value;
                  });
                  this.onChoose(_selectedField);
                },
                items: commonFields.map((field){
                  return DropdownMenuItem(
                    child: Text(field),
                    value: field,
                  );
                }).toList()
            ),
          ],
        )
    );;
  }
}


