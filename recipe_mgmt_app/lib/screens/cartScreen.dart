import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/cart.dart';
import 'package:recipe_mgmt_app/models/recipe.dart';
import 'package:recipe_mgmt_app/screens/newRecipeScreen.dart';
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
      ),
      body: getRecipeListView(),//getRecipeListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Recipe newRecipe = Recipe('', ' ');
          navigateToNewRecipe(newRecipe, 'Add Recipe');
        },
        tooltip: 'Add New Recipe',
        child: Icon(Icons.add),
      )
    );
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
                // Checkbox(
                //   value: false, 
                //   onChanged: (bool value) {
                //     print('value changed');
                //   },
                // ),
                Text(
                  recipeList[position].name,
                  style: titleStyle,
                ),
                Text(
                  recipeList[position].category,
                  style: titleStyle,
                ),
                FlatButton(
                  child: Icon(Icons.delete),
                  onPressed: () {
                    _delete(context, recipeList[position]);
                  },
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
				setState(() {
				  this.recipeList = recipeList;
				  this.countRecipes = recipeList.length;
				});
			});
		});
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

  // Delete Recipe from table 
  void _delete(BuildContext context, Recipe recipe) async {
    int result = await dbHelper.deleteRecipe(recipe.id);
		if (result != 0) {
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