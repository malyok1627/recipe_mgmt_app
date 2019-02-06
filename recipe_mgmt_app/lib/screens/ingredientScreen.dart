import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/measurementUnit.dart';
import 'package:recipe_mgmt_app/screens/newUnitScreen.dart';
import 'dart:async';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class IngredientScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IngredientScreenState();
  }
}

class IngredientScreenState extends State<IngredientScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<MeasurementUnit> measurementUnitList;
  int countMeasurementUnits = 0;

  // Value relevant for the Title
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Instance of a measurementUnitList object
    if(measurementUnitList == null) {
      measurementUnitList = List<MeasurementUnit>();
      updateListView();
    }
    TextStyle titleText = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text("Ingredient"),
      ),
      body: Column(
        children: <Widget>[
          // Ingredient name - TextField
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: titleController,
              style: titleText,
              onChanged: (value) {
                debugPrint("The value changed to: $value");
              },
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: titleText,
                contentPadding:
                    EdgeInsets.only(left: 20, bottom: 15.0, top: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          // List of available units - Cards
          Expanded(
            child: getIngredientListView(),
          ),

          // Save button
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Theme.of(context).primaryColorDark,
              textColor: Colors.black,
              child: Text("Save", textScaleFactor: 1.5,),
              elevation: 10.0,
              onPressed: () {
                setState(() {
                  debugPrint("Save button pressed");
                });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new Ingredient!
          debugPrint("FAB pressed");
          navigateToNewUnit(MeasurementUnit(""));
        },
        tooltip: "Add Measurement Unit",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getIngredientListView() {
    TextStyle titleText = Theme.of(context).textTheme.title;

    // Values relevant for the input
    //TextEditingController unitController = TextEditingController();

    return ListView.builder(
      itemCount: countMeasurementUnits,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 10.0,
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              // Text
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  this.measurementUnitList[position].name,
                  style: titleText,
                ),
              ),

              // Delete Icon
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
                child: GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    debugPrint("Unit deleted!");
                    _delete(context, measurementUnitList[position]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Delete function
  void _delete(BuildContext context, MeasurementUnit unit) async {
		int result = await databaseHelper.deleteMeasurementUnit(unit.id);
		if (result != 0) {
			_showSnackBar(context, 'Unit Deleted Successfully');
			updateListView();
		}
  }
  // Pop Notification at the bottom
  void _showSnackBar(BuildContext context, String message) {
		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
  }

  // Update ListView
  void updateListView() {
		final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
		dbFuture.then((database) {
			Future<List<MeasurementUnit>> measurementUnitListFuture = databaseHelper.getMeasurementUnitList();
			measurementUnitListFuture.then((measurementUnitList) {
				setState(() {
				  this.measurementUnitList = measurementUnitList;
				  this.countMeasurementUnits = measurementUnitList.length;
				});
			});
		});
  }

  // Navigation function
  void navigateToNewUnit(MeasurementUnit unit) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NewUnitScreen(unit);
	  }));

	  if(result == true) {
	  	updateListView();
    }  
  } 

}
