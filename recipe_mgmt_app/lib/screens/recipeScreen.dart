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
  double amount;

  // Value relevant for the Title
  TextEditingController amountController = TextEditingController();

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
            tooltip: 'Save Cart',
            onPressed: () {
              addIngredientsToCart();
              moveToLastScreen();
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

  // Delete Recipe from table
  void _delete(BuildContext context, Ingredient ingredient) async {
    int result = await dbHelper.deleteIngredient(ingredient.id);
    if (result != 0) {
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

  // Update name of Cart object
  void updateName() {
    amount = double.tryParse(amountController.text);
  }

  void addIngredientsToCart() {
    // Add recipes to cart in DB
    for (int i = 0; i < numOfCheckboxes.length; i++) {
      bool tempVal = numOfCheckboxes[i];
      if (tempVal == true) {
        dbHelper.insertIngredientToRecipe(
            recipe.id, ingredientList[i].id, amount);
        String ingredientName = ingredientList[i].name;
        print(ingredientName);
      }
    }
  }

  // Update List View
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Ingredient>> ingredientListFuture =
          dbHelper.getIngredientList();
      ingredientListFuture.then((ingredientList) {
        List<int> ingredientsId = List<int>(ingredientList.length);

        // Get recipes in this cart
        Future<List<Ingredient>> ingredientsInCartListFuture =
            dbHelper.getIngredientInRecipeList(recipe.id);
        ingredientsInCartListFuture.then((ingredientsInCartList) {
          for (int i = 0; i < ingredientsInCartList.length; i++) {
            ingredientsId[ingredientsInCartList[i].id - 1] =
                ingredientsInCartList[i].id;
          }

          // Find the length difference between recipes and add appropriate amount of checkboxes
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
                        width: 200.0,
                        child: TextFormField(
                          controller: amountController,
                          style: titleStyle,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            } else {
                              updateName();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Ingredient amount",
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

                // Delete Button
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Icon(Icons.delete),
                    onPressed: () {
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
