import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/measurementUnit.dart';
import 'dart:async';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class NewUnitScreen extends StatefulWidget {
  final MeasurementUnit unit; 

  NewUnitScreen(this.unit);

  @override
  State<StatefulWidget> createState() {
    return NewUnitScreenState(this.unit);
  }
}

class NewUnitScreenState extends State<NewUnitScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  MeasurementUnit unit;

  // Value relevant for the Title
  TextEditingController nameController = TextEditingController();

  NewUnitScreenState(this.unit);

  @override
  Widget build(BuildContext context) {
    TextStyle titleText = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new mesurement unit"),
      ),
      body: Column(
        children: <Widget>[
          // Title of a measurement unit - TextField
          // Unit name - TextField
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: nameController,
              style: titleText,
              onChanged: (value) {
                debugPrint("The value changed to: $value");
                updateName();
              },
              decoration: InputDecoration(
                labelText: "Unit",
                labelStyle: titleText,
                contentPadding:
                    EdgeInsets.only(left: 20, bottom: 15.0, top: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          
          // Save button
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Theme.of(context).primaryColorDark,
              textColor: Colors.black,
              child: Text("Save", textScaleFactor: 1.5,),
              onPressed: () {
                setState(() {
                  debugPrint("Save button pressed");
                  _save();
                });
              },
            ),
          )
        ],
      )
    );
  }

  // Update name of Unit object
  void updateName() {
    unit.name = nameController.text;
  }

  // Save data to database
	void _save() async {
    moveToLastScreen();
    // Only INSERT operation
    int result = await databaseHelper.insertMeasurementUnit(unit);

    if(result != 0) {  // Success
			_showAlertDialog('Status', 'Unit Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Unit');
		}
  }

  void _showAlertDialog(String title, String message) {
		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog,
		);
  } 

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

}
