import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:recipe_mgmt_app/models/recipe.dart';
import 'package:recipe_mgmt_app/screens/ingredientScreen.dart';
import 'package:recipe_mgmt_app/screens/newIngredientScreen.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class RecipeScreen extends StatefulWidget {
  final String appBarTitle;
  final Recipe recipe;

  RecipeScreen(this.recipe, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return RecipeScreenState(this.recipe, this.appBarTitle);
  }
}

class RecipeScreenState extends State<RecipeScreen> {
  String appBarTitle;
  Recipe recipe;

  RecipeScreenState(this.recipe, this.appBarTitle);

  DatabaseHelper dbHelper = DatabaseHelper();
  List<Ingredient> ingredientList;
  List<bool> numOfCheckboxes = List<bool>();
  int countIngredients = 0;
  List<double> amountList;
  // Used for text validation
  final _formKey = GlobalKey<FormState>();

  // Value relevant for checkbox
  List<TextEditingController> _amountControllers = new List();

  @override
  Widget build(BuildContext context) {
    if (ingredientList == null) {
      ingredientList = List<Ingredient>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Recipe',
            onPressed: () {
              //setState(() {
                //if (_formKey.currentState.validate()) {
                  // for (int i=0; i<amountList.length; i++) {
                  //   print(amountList[i]);
                  // } 
                //}
              //});
     
              // addIngredientsToCart();
              // moveToLastScreen();
              // _showAlertDialog('Status', 'Recipe Saved Successfully');

              
            },
          ),
        ],
      ),
      body: getIngredientListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Ingredient newIngredient = Ingredient('', null);
          navigateToNewIngredient(newIngredient, 'Add Ingredient');
        },
        tooltip: "Add Ingredient",
        child: Icon(Icons.add),
      ),
    );
  }

  // Monitor checkbox changes
  void boxStateChange(bool value, int position) {
    setState(() {
      numOfCheckboxes[position] = value;
    });
  }

  // Show alert dialog
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  // Delete Recipe from table
  void _delete(BuildContext context, Ingredient ingredient) async {
    int result1 = await dbHelper.deleteIngredient(ingredient.id);
    int result2 = await dbHelper.deleteIngredientFromRecipe(recipe.id, ingredient.id);
    if (result1 != 0 && result2 != 0) {
      _showSnackBar(context, 'Ingredient Deleted Successfully');
      updateListView();
    }
  }

  // Move back
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Snack bar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // Navigate to New Recipe
  void navigateToNewIngredient(Ingredient ingredient, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewIngredientScreen(ingredient, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // Update amount of ingredient
  void updateAmount(int position) {
    setState(() {
      amountList[position] = double.parse(_amountControllers[position].text);
    });
  }

  void addIngredientsToCart() {
    // Add recipes to cart in DB
    for (int i = 0; i < numOfCheckboxes.length; i++) {
      bool tempVal = numOfCheckboxes[i];
      if (tempVal == true) {
        dbHelper.insertIngredientToRecipe(recipe.id, ingredientList[i].id, amountList[i]);        
      }
    }
  }

  // Update List View
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Ingredient>> ingredientListFuture = dbHelper.getIngredientList();
      ingredientListFuture.then((ingredientList) {
        List<int> ingredientsId = List<int>(ingredientList.length);

        // Get ingredients in this recipe
        Future<List<Ingredient>> ingredientsInRecipeListFuture = dbHelper.getIngredientInRecipeList(recipe.id);
        ingredientsInRecipeListFuture.then((ingredientsInRecipeList) {
          for (int i = 0; i < ingredientsInRecipeList.length; i++) {
            ingredientsId[ingredientsInRecipeList[i].id - 1] = ingredientsInRecipeList[i].id;
            // Get amount value for each ingredient
            var ingredientMapListFuture = dbHelper.getRecipeIngredient(recipe.id, ingredientsId[ingredientsInRecipeList[i].id - 1]);
            ingredientMapListFuture.then((ingredientMapList) {
              amountList[i] = ingredientMapList[0]['amount'];
            });
          }

          // Find the length difference between ingredients and add appropriate amount of checkboxes
          int lengthDiff = ingredientList.length - numOfCheckboxes.length;
          if (lengthDiff > 0) {
            for (int i = 0; i < lengthDiff; i++) {
              // check if this index corresponds to recipesInCartList
              if (ingredientsId[i] == null) {
                numOfCheckboxes.add(false);
              } else {
                numOfCheckboxes.add(true);
              }
            }
          } else if (lengthDiff < 0) {
            for (int i = 0; i < lengthDiff; i++) {
              numOfCheckboxes.removeLast();
            }
          }
          // Save state
          setState(() {
            this.ingredientList = ingredientList;
            this.countIngredients = ingredientList.length;
            this.amountList = List<double>(countIngredients);
          });
        });
      });
    });
  }

  // Get List of ingredients
  ListView getIngredientListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: countIngredients,
      itemBuilder: (BuildContext context, int position) {
        // Add an amountController
        _amountControllers.add(new TextEditingController());

        return Card(
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                // Checkbox
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Checkbox(
                    value: numOfCheckboxes[position],
                    onChanged: (bool value) {
                      boxStateChange(value, position);
                    },
                  ),
                ),
                Column(
                  children: <Widget>[
                    // Ingredient Name
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        ingredientList[position].name,
                        style: titleStyle,
                      ),
                    ),
                    // Amount of Ingredient -> TextField
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Container(
                        height: 55.0,
                        width: 230.0,
                        child: TextField(
                          controller: _amountControllers[position],
                          style: titleStyle,
                          onChanged: (value) {
                            updateAmount(position);
                          },
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return "Please enter some text";
                          //   } else {
                          //     updateName(position);
                          //   }
                          // },
                          decoration: InputDecoration(
                            labelText: amountList[position].toString(),
                            labelStyle: titleStyle,
                            contentPadding: EdgeInsets.only(
                                left: 20, bottom: 15.0, top: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Ingredient unit
                Container(
                  height: 5.0,
                  width: 20.0,
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(ingredientList[position].unitName),
                ),

                // Delete Button
                Container(
                  height: 20.0,
                  width: 30.0,
                  child: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () {
                      _delete(context, ingredientList[position]);
                    },
                  ),                  
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
