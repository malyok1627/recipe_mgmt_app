import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:recipe_mgmt_app/models/recipe.dart';
import 'package:recipe_mgmt_app/screens/dropDownFormField.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:image_picker/image_picker.dart';

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
    'breakfast',
    'dessert',
    'main dish',
    'salad',
    'soup',
  ];

  String appBarTitle;
  Recipe recipe;
  dynamic _image;
  dynamic base64 = const Base64Codec() ;

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
            // Enter recipe name
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
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
                  contentPadding: EdgeInsets.only(left: 10, bottom: 10.0, top: 10.0),
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
                  child: Text(
                    'Recipe category:',
                    style: titleText
                  ),
                ),

                // Category drop down menu
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text('category'),
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
                      style: titleText,
                    ),
                  ),
                )
              ],
            ),
            Container(
              child: Container(
                child: _image == null 
                ? Text('Recipe image will be displayed here...')
                : ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: Image.file(_image),
                ),
                padding: EdgeInsets.all(10.0),
              ),
            ),       
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImageFromGallery();
        },
        tooltip: "Add recipe picture",
        child: Icon(Icons.photo),
        backgroundColor: Theme.of(context).indicatorColor,
        foregroundColor: Theme.of(context).selectedRowColor,
      ),
    );
  }

  // Handle selected image
  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      //maxWidth: 600,
      //maxHeight: 400,
    );
    
    
    setState(() {
      _image = image;
    });

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

    if (result == 0) {
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
