import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/cart.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:recipe_mgmt_app/models/recipe.dart';
import 'package:recipe_mgmt_app/screens/newRecipeScreen.dart';
import 'package:recipe_mgmt_app/screens/recipeScreen.dart';
import 'package:recipe_mgmt_app/screens/shoppingListScreen.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class CartScreen extends StatefulWidget {
  final String appBarTitle;
  final Cart cart;

  CartScreen(this.cart, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return CartScreenState(this.cart, this.appBarTitle);
  }
}

class CartScreenState extends State<CartScreen> {
  String appBarTitle;
  Cart cart;

  CartScreenState(this.cart, this.appBarTitle);

  DatabaseHelper dbHelper = DatabaseHelper();
  List<Recipe> recipeList;
  List<bool> numOfCheckboxes = List<bool>();
  int countRecipes = 0;

  @override
  Widget build(BuildContext context) {
    if (recipeList == null) {
      recipeList = List<Recipe>();
      updateListView();
    }

    // Define text style
    TextStyle titleText = Theme.of(context).textTheme.title;

    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save Cart',
              onPressed: () {
                addRecipesToCart();
                moveToLastScreen();
                _showAlertDialog('Status', 'Cart Saved Successfully');
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: getRecipeListView(),
            ),

            // ShowGroceryList button
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Colors.black,
                child: Text(
                  "Show Grocery List",
                  textScaleFactor: 1.4,
                ),
                elevation: 10.0,
                onPressed: () async {
                  Map<String, dynamic> shoppingList = await getShoppingList();
                  navigateToShoppingList(shoppingList);
                },
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Recipe newRecipe = Recipe('', null);
            navigateToNewRecipe(newRecipe, 'Add Recipe');
          },
          tooltip: 'Add New Recipe',
          child: Icon(Icons.add),
        ));
  }

  ListView getRecipeListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: countRecipes,
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
                // Recipe name
                Container(
                  width: 125.0,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: FlatButton(
                      child: Text(
                        recipeList[position].name,
                        style: titleStyle,
                      ),
                      onPressed: () {
                        navigateToRecipe(
                            this.recipeList[position], 'Edit Recipe');
                      },
                    ),
                  ),
                ),

                // Recipe category
                // TODO check if the category is chosen!
                Container(
                  width: 120.0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      recipeList[position].category,
                      style: titleStyle,
                    ),
                  ),
                ),

                // Delete Button
                Container(
                  height: 20.0,
                  width: 30.0,
                  child: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () {
                      _delete(context, recipeList[position]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Update List View
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Recipe>> recipeListFuture = dbHelper.getRecipeList();
      recipeListFuture.then((recipeList) {
        List<int> recipesId = List<int>(recipeList.length);

        // Get recipes in this cart
        Future<List<Recipe>> recipesInCartListFuture =
            dbHelper.getRecipeInCartList(cart.id);
        recipesInCartListFuture.then((recipesInCartList) {
          for (int i = 0; i < recipesInCartList.length; i++) {
            recipesId[recipesInCartList[i].id - 1] = recipesInCartList[i].id;
          }

          // Find the length difference between recipes and add appropriate amount of checkboxes
          int lengthDiff = recipeList.length - numOfCheckboxes.length;
          if (lengthDiff > 0) {
            for (int i = 0; i < lengthDiff; i++) {
              // check if this index corresponds to recipesInCartList
              if (recipesId[i] == null) {
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
            this.recipeList = recipeList;
            this.countRecipes = recipeList.length;
          });
        });
      });
    });
  }

  // Display grocery list
  Future<Map<String, dynamic>> getShoppingList() async {
    Map<String, dynamic> groceryList = Map<String, dynamic>();

    // Get all recipes in cart
    List<Recipe> recipeInCartList = await dbHelper.getRecipeInCartList(cart.id);
    
    for (int i = 0; i < recipeInCartList.length; i++) {
      int recipeId = recipeInCartList[i].id;

      // Get all ingredients in recipe
      List<Ingredient> ingredientInRecipeList = await dbHelper.getIngredientInRecipeList(recipeId);
      for (int j = 0; j < ingredientInRecipeList.length; j++) {

        // Get ingredient info
        int ingredientId = ingredientInRecipeList[j].id;
        String ingredientName = ingredientInRecipeList[j].name;

        // Get amount value for each ingredient
        List<Map<String, dynamic>> ingredientMap = await dbHelper.getRecipeIngredient(recipeId, ingredientId);

        double amount = ingredientMap[0]['amount'];

        // If there is an ingredient in the list already -> update an amount
        if (groceryList.containsKey(ingredientName)) {
          groceryList[ingredientName] = groceryList[ingredientName] + amount;
        } // Otherwise add it to the list
        else {
          groceryList[ingredientName] = amount;
        }        
      }
    }
    return groceryList;
  }

  // Show alert dialog
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  // Monitor checkbox changes
  void boxStateChange(bool value, int position) {
    setState(() {
      numOfCheckboxes[position] = value;
    });
  }

  // Move back
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Add Recipes to Cart
  void addRecipesToCart() {
    // Add recipes to cart in DB
    for (int i = 0; i < numOfCheckboxes.length; i++) {
      bool tempVal = numOfCheckboxes[i];
      if (tempVal == true) {
        dbHelper.insertRecipeToCart(cart.id, recipeList[i].id);
      }
    }
  }

  // Navigate to New Recipe
  void navigateToNewRecipe(Recipe recipe, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewRecipeScreen(recipe, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // Navigate to Existing Recipe
  void navigateToRecipe(Recipe recipe, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RecipeScreen(recipe, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // Navigate to Shopping List
  void navigateToShoppingList(Map<String, dynamic> list) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ShoppingListScreen(list);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // Delete Recipe from table
  void _delete(BuildContext context, Recipe recipe) async {
    int result1 = await dbHelper.deleteRecipe(recipe.id);
    int result2 = await dbHelper.deleteRecipeFromCart(cart.id, recipe.id);
    if (result1 != 0 && result2 != 0) {
      _showSnackBar(context, 'Recipe Deleted Successfully');
      updateListView();
    }
  }

  // Snack bar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
