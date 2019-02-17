import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:recipe_mgmt_app/models/recipe.dart';
import 'package:recipe_mgmt_app/screens/dropDownFormField.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';

class NewRecipeScreen extends StatefulWidget {
  final String appBarTitle;
  final Recipe recipe;

  NewRecipeScreen(this.recipe, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NewRecipeScreenState(this.recipe, this.appBarTitle);
  }
}

class NewRecipeScreenState extends State<NewRecipeScreen> {
  // Possible categories for recipe
  static var _categories = [
    'dessert',
    'salad',
    'soup',
    'main dish',
    'breakfast'
  ];

  String appBarTitle;
  Recipe recipe;

  // Used for text validation
  final _formKey = GlobalKey<FormState>();
  // Value relevant for cart name
  TextEditingController nameController = TextEditingController();
  // Initialize DB helper
  DatabaseHelper dbHelper = DatabaseHelper();

  NewRecipeScreenState(this.recipe, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    // Define text style
    TextStyle titleText = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Cart',
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
            // Recipe name - TextField
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
              child: TextFormField(
                controller: nameController,
                style: titleText,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter recipe title";
                  } else {
                    updateName();
                  }
                },
                decoration: InputDecoration(
                  labelText: "Recipe title",
                  labelStyle: titleText,
                  contentPadding:
                      EdgeInsets.only(left: 20, bottom: 15.0, top: 15.0),
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
                  padding: EdgeInsets.all(10.0),
                  child: Text('Recipe category:', style: titleText),
                ),

                // Padding(
                //   padding: EdgeInsets.all(10.0),
                //   child: DropdownFormField<String>(
                //   validator: (value) {
                //     if (value == null) {
                //       return 'Required';
                //     }
                //   },
                //   onSaved: (value) {
                //     // ...
                //   },
                //   decoration: InputDecoration(
                //     border: UnderlineInputBorder(),
                //     filled: true,
                //     labelText: 'Demo',
                //   ),
                //   initialValue: null,
                //   items: [
                //     DropdownMenuItem<String>(
                //       value: '1',
                //       child: Text('1'),
                //     ),
                //     DropdownMenuItem<String>(
                //       value: '2',
                //       child: Text('2'),
                //     )
                //   ],
                // ),
                // ),


                ///////
                ///
                
                ///
                ///////

                // Category drop down menu
                // TODO check if category was chosen
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: new Text("select category"),
                      value: recipe.category,
                      onChanged: (value) {
                        setState(() {
                          recipe.category = value;
                        });
                      },
                      items: _categories.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                

                // Padding(
                //   padding: EdgeInsets.all(10.0),
                //   child: DropdownButton(
                //     items: _categories.map((String dropDownStringItem) {
                //       return DropdownMenuItem<String>(
                //         value: dropDownStringItem,
                //         child: Text(dropDownStringItem),
                //       );
                //     }).toList(),
                //     style: titleText,
                //     value: recipe.category,
                //     onChanged: (value) {
                //       setState(() {
                //         recipe.category = value;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Update name of Cart object
  void updateName() {
    recipe.name = nameController.text;
  }

  // Save cart to DB
  void _save() async {
    moveToLastScreen();

    // Add to DB table
    int result = await dbHelper.insertRecipe(recipe);

    if (result != 0) {
      _showAlertDialog('Status', 'Recipe Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Error Saving Recipe');
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
