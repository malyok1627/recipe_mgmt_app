import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/measurementUnit.dart';
import 'package:recipe_mgmt_app/screens/newUnitScreen.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'dart:async';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class IngredientScreen extends StatefulWidget {
  final Ingredient ingredient;

  IngredientScreen(this.ingredient);

  @override
  State<StatefulWidget> createState() {
    return IngredientScreenState(this.ingredient);
  }
}

class IngredientScreenState extends State<IngredientScreen> {
  Ingredient ingredient;

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<MeasurementUnit> measurementUnitList;
  int countMeasurementUnits = 0;

  // Value relevant for the Title
  TextEditingController nameController = TextEditingController();

  IngredientScreenState(this.ingredient);

  @override
  Widget build(BuildContext context) {
    // Instance of a measurementUnitList object
    if (measurementUnitList == null) {
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
              controller: nameController,
              style: titleText,
              onChanged: (value) {
                debugPrint("The value changed to: $value");
                updateName();
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
              child: Text("Save", textScaleFactor: 1.4,),
              elevation: 10.0,
              onPressed: () {
                setState(() {
                  String name = ingredient.name;
                  List<MeasurementUnit> unitsList = ingredient.measurementUnits;
                  MeasurementUnit firstUnit = unitsList[1];
                  String unitName = firstUnit.name;
                  debugPrint("$unitsList");
                });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB pressed");
          // Create new Unit
          MeasurementUnit newUnit = MeasurementUnit("");
          // Add it to the list of units for this Ingredient
          ingredient.addNewMeasurementUnit(newUnit);
          navigateToNewUnit(newUnit);
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

  // Update name of Ingredient object
  void updateName() {
    ingredient.name = nameController.text;
  }

  // Delete function
  void _delete(BuildContext context, MeasurementUnit unit) async {
    // Perform delete from a DB
		int result = await databaseHelper.deleteMeasurementUnit(unit.id);
    // Perform delete from a list of Units for certain Ingredient
    ingredient.deleteMeasurementUnit(unit);
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
