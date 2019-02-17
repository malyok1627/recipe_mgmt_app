import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/measurementUnit.dart';
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
  // Used for text validation
  final _formKey = GlobalKey<FormState>();

  static var _units = ['g', 'ml'];

  Ingredient ingredient;

  DatabaseHelper databaseHelper = DatabaseHelper();
  //List<MeasurementUnit> measurementUnitList;
  //int countMeasurementUnits = 0;

  // Value relevant for the Title
  TextEditingController nameController = TextEditingController();

  IngredientScreenState(this.ingredient);

  @override
  Widget build(BuildContext context) {
    // Instance of a measurementUnitList object
    // if (measurementUnitList == null) {
    //   measurementUnitList = List<MeasurementUnit>();
    //   //updateListView();
    // }
    TextStyle titleText = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ingredient",
          style: TextStyle(fontWeight: FontWeight.bold),  
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Ingredient name - TextField
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
              child: TextFormField(
                controller: nameController,
                style: titleText,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  } else {
                    updateName();
                    print('$value');
                  }
                },
                decoration: InputDecoration(
                  labelText: "Ingredient",
                  labelStyle: titleText,
                  contentPadding:
                      EdgeInsets.only(left: 20, bottom: 15.0, top: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            // List of available units - Cardsd
            //Expanded(
            //  child: getIngredientListView(),
            //),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: DropdownButton(
                items: _units.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                style: titleText,
                value: ingredient.unitName,
                onChanged: (value) {
                  setState(() {
                    debugPrint('User selected $value');
                    ingredient.unitName = value;
                  });
                },
              ),
            ),

            // Save button
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Colors.black,
                child: Text(
                  "Save",
                  textScaleFactor: 1.4,
                ),
                elevation: 10.0,
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      _save();
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     debugPrint("FAB pressed");
      //     // Create new Unit
      //     MeasurementUnit newUnit = MeasurementUnit('');
      //     // Add it to the list of units for this Ingredient
      //     //ingredient.addNewMeasurementUnit(newUnit);
      //     navigateToNewUnit(newUnit);
      //   },
      //   tooltip: "Add Measurement Unit",
      //   child: Icon(Icons.add),
      // ),
    );
  }

  ListView getIngredientListView() {
    TextStyle titleText = Theme.of(context).textTheme.title;

    // Values relevant for the input
    //TextEditingController unitController = TextEditingController();

    return ListView.builder(
      itemCount: 0, //countMeasurementUnits,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 10.0,
          margin:
              EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              // Text
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  '',
                  //this.measurementUnitList[position].name,
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
                    //_delete(context, measurementUnitList[position], position);
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

  // Save function
  void _save() async {
    moveToLastScreen();
    //databaseHelper.addIngredientsTable();
    // Only INSERT operation
    int result = await databaseHelper.insertIngredient(ingredient);

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Ingredient Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Ingredient');
    }
  }

  // Delete function
  void _delete(BuildContext context, MeasurementUnit unit, int position) async {
    // Perform delete from a DB
    // int result = await databaseHelper.deleteMeasurementUnit(unit.id);
    // // Perform delete from a list of Units for certain Ingredient
    // //ingredient.deleteMeasurementUnit(position);
    // if (result != 0) {
    //   _showSnackBar(context, 'Unit Deleted Successfully');
    //   updateListView();
    // }
  }

  // Pop Notification at the bottom
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
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

  // Update ListView
  // void updateListView() {
  //   final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<MeasurementUnit>> measurementUnitListFuture =
  //         databaseHelper.getMeasurementUnitList();
  //     measurementUnitListFuture.then((measurementUnitList) {
  //       setState(() {
  //         this.measurementUnitList = measurementUnitList;
  //         this.countMeasurementUnits = measurementUnitList.length;
  //       });
  //     });
  //   });
  // }

  // Navigation function
  // void navigateToNewUnit(MeasurementUnit unit) async {
  //   bool result =
  //       await Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return NewUnitScreen(unit);
  //   }));

  //   if (result == true) {
  //     updateListView();
  //   }
  // }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
