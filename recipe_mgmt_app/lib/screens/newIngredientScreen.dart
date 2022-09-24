import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';

class NewIngredientScreen extends StatefulWidget {
  final String appBarTitle;
  final Ingredient ingredient;

  NewIngredientScreen(this.ingredient, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NewIngredientScreenState(this.ingredient, this.appBarTitle);
  }
}

class NewIngredientScreenState extends State<NewIngredientScreen> {
  // Possible categories for recipe
  static var _units = [
    'g',
    'ml',
  ];

  String appBarTitle;
  Ingredient ingredient;

  // Used for text validation
  final _formKey = GlobalKey<FormState>();
  // Value relevant for cart name
  TextEditingController nameController = TextEditingController();
  // Initialize DB helper
  DatabaseHelper dbHelper = DatabaseHelper();

  NewIngredientScreenState(this.ingredient, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    // Define text style
    TextStyle titleText = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Ingredient',
            onPressed: () {
              setState(() {
                if (_formKey.currentState.validate()) {
                  _save();
                }
              });
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Ingredient title
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
              child: TextFormField(
                controller: nameController,
                style: titleText,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter ingredient title";
                  } else {
                    updateName();
                  }
                },
                maxLength: 25,
                decoration: InputDecoration(
                  labelText: "Ingredient title",
                  labelStyle: titleText,
                  contentPadding:
                      EdgeInsets.only(left: 10, bottom: 10.0, top: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            Row(
              children: <Widget>[
                // Additional text
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 5.0),
                  child: Text('Measurement unit:', style: titleText),
                ),

                // Unit drop down menu
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text('unit'),
                      value: ingredient.unitName,
                      onChanged: (value) {
                        setState(() {
                          ingredient.unitName = value;
                        });
                      },
                      items: _units.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: titleText,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Update name of Cart object
  void updateName() {
    ingredient.name = nameController.text;
  }

  // Save cart to DB
  void _save() async {
    moveToLastScreen();

    // Add to DB table
    int result = await dbHelper.insertIngredient(ingredient);

    if (result == 0) {
      _showAlertDialog('Status', 'Error Saving Ingredient');
    }
  }

  // Move back
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Show alert dialog
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
