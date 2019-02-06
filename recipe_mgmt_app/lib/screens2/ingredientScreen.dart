import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';

class IngredientScreen extends StatefulWidget {
  final String appBarTitle;

  IngredientScreen(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return IngredientScreenState(this.appBarTitle);
  }
}

class IngredientScreenState extends State<IngredientScreen> {
  int countUnits = 0;
  String appBarTitle;
  Ingredient ingredient;

  TextEditingController titleController = TextEditingController();

  IngredientScreenState(this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    // LAST END!
    titleController.text = ingredient.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            // Text
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  //updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Horizontal line
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                color: Theme.of(context).secondaryHeaderColor,
                height: 8.0,
              ),
            ),

            // Text
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text(
                "Measurement units",
                style: textStyle,
              ),
            ),

            // List of available units with delete button
            Expanded(
              child: getUnitsListView(),
            ),

            // Add button at the buttom
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add new measurement unit",
                onPressed: () {
                  debugPrint("Add button pressed!");
                },
              ),
            ),

            // Save Raised Button button at the very end
            Padding(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text(
                  "Save",
                  textScaleFactor: 1.5,
                ),
                onPressed: () {
                  setState(() {
                    debugPrint("Save button clicked!");
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView getUnitsListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: countUnits,
      itemBuilder: (BuildContext context, int position) {
        return Row(
          children: <Widget>[
            Text(
              "g",
              style: titleStyle,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              tooltip: "Delete measurement unit",
              onPressed: () {
                debugPrint("Delete button pressed!");
              },
            ),
          ],
        );
      },
    );
  }
}
