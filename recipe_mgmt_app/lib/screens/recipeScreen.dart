import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:recipe_mgmt_app/models/recipe.dart';
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
  List<String> amountList = List<String>();
  int countIngredients = 0;

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
        title: Text(
          appBarTitle + ': ' + recipe.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Recipe',
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
      body: Column(
        children: <Widget>[
          // Add an image here
          // DecoratedBox(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10.0),
          //   ),
          // ),
          // Container(
          //   child: Container(
          //     child: ClipRRect(
          //       borderRadius: new BorderRadius.circular(10.0),
          //       child: Image.network(
          //         'https://i0.wp.com/www.theeasyvegan.org/wp-content/uploads/2019/01/Fish-and-Chips-Base-Thumb-2.jpg?resize=768%2C432&ssl=1',
          //       ),
          //     ),
          //   ),
          //   padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
          // ),
          Expanded(
            child: Form(
              key: _formKey,
              child: getIngredientListView(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Ingredient newIngredient = Ingredient('', 'g');
          navigateToNewIngredient(newIngredient, 'Add Ingredient');
        },
        tooltip: "Add Ingredient",
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).indicatorColor,
        foregroundColor: Theme.of(context).selectedRowColor,
      ),
    );
  }

  // Get List of ingredients
  ListView getIngredientListView() {
    TextStyle subheadStyle = Theme.of(context).textTheme.titleSmall;
    TextStyle titleStyle = Theme.of(context).textTheme.titleMedium;

    return ListView.builder(
      itemCount: countIngredients,
      itemBuilder: (BuildContext context, int position) {
        // Add an amountController
        //_amountControllers.add(new TextEditingController());

        return Card(
          elevation: 4.0,
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      // Checkbox
                      Checkbox(
                        value: numOfCheckboxes[position],
                        onChanged: (bool value) {
                          boxStateChange(value, position);
                        },
                      ),

                      // Ingredient Name
                      Container(
                        width: MediaQuery.of(context).size.width - 210,
                        child: Text(
                          ingredientList[position].name,
                          style: titleStyle,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      )
                    ],
                  ),
                ),

                Spacer(),

                Container(
                  child: Row(
                    children: <Widget>[
                      // Ingredient amount
                      Container(
                        width: 80.0,
                        child: TextFormField(
                          controller: _amountControllers[position],
                          style: subheadStyle,
                          validator: (value) {
                            if (numOfCheckboxes[position] == true &&
                                value.isEmpty) {
                              return '    add value';
                            } else {
                              updateAmount(position);
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 10, bottom: 10.0, top: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),

                      // Ingredient unit
                      Container(
                        width: 30.0,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(ingredientList[position].unitName),
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete Button
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    child: Icon(Icons.delete,
                        color: Theme.of(context).selectedRowColor),
                    onTap: () {
                      _delete(context, ingredientList[position]);
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
      Future<List<Ingredient>> ingredientListFuture =
          dbHelper.getIngredientList();
      ingredientListFuture.then((ingredientList) {
        // Empty checkboxes variabel
        numOfCheckboxes = List<bool>();
        amountList = List<String>();

        // Prepare map for checkboxes and amount
        Map<int, bool> checkIngredientId = Map<int, bool>();
        Map<int, String> checkIngredientAmount = Map<int, String>();
        for (int i = 0; i < ingredientList.length; i++) {
          checkIngredientId[ingredientList[i].id] = false;
          checkIngredientAmount[ingredientList[i].id] = '';
        }

        // Get ingredients in this recipe
        Future<List<Ingredient>> ingredientsInRecipeListFuture =
            dbHelper.getIngredientInRecipeList(recipe.id);
        ingredientsInRecipeListFuture.then((ingredientsInRecipeList) async {
          for (int i = 0; i < ingredientsInRecipeList.length; i++) {
            checkIngredientId[ingredientsInRecipeList[i].id] = true;

            // Get amount for each ingredient
            List<Map<String, dynamic>> ingredientMapList = await dbHelper
                .getRecipeIngredient(recipe.id, ingredientsInRecipeList[i].id);
            // Get ingredient information and store it
            int ingredientId = ingredientMapList[0]['ingredientId'];
            String ingredientAmount = ingredientMapList[0]['amount'].toString();
            checkIngredientAmount[ingredientId] = ingredientAmount;
          }

          // Organize checkboxes and amountList
          for (int i = 0; i < checkIngredientId.length; i++) {
            // Prepare variables
            bool boolToAdd = checkIngredientId.values.elementAt(i);
            String strToAdd = checkIngredientAmount.values.elementAt(i);

            // Add them in order to present on the screen
            amountList.add(strToAdd);
            numOfCheckboxes.add(boolToAdd);

            // Add TextController
            _amountControllers.add(new TextEditingController());
            if (strToAdd.isNotEmpty) {
              int strLen = strToAdd.length;
              _amountControllers[i].text =
                  strToAdd.replaceRange(strLen - 2, strLen, '');
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

  // Update checkbox changes
  void boxStateChange(bool value, int position) {
    setState(() {
      numOfCheckboxes[position] = value;
    });
  }

  // Get units in int
  String getAndCorrectUnits(String unit) {
    if (unit.isNotEmpty) {
      int strLen = unit.length;
      String correctedString = unit.replaceRange(strLen - 2, strLen, '');
      return correctedString;
    } else {
      return '';
    }
  }

  // Update amount of ingredient
  void updateAmount(int position) {
    setState(() {
      amountList[position] = _amountControllers[position].text;
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

  // Save button pressed
  void _save() async {
    // Delete all entries from bridge table
    deleteRecipesFromCart();
    // Add marked recipes to bridge table
    addIngredientsToRecipe();
    // Move to last screen
    moveToLastScreen();
  }

  // Delete all Ingredients from Recipe
  void deleteRecipesFromCart() {
    dbHelper.deleteAllIngredientsFromRecipe(recipe.id);
  }

  // Delete Recipe from table
  void _delete(BuildContext context, Ingredient ingredient) async {
    int result1 = await dbHelper.deleteIngredient(ingredient.id);
    await dbHelper.deleteIngredientFromRecipe(recipe.id, ingredient.id);
    if (result1 != 0) {
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
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    //Scaffold.of(context).showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  void addIngredientsToRecipe() async {
    // Add recipes to cart in DB
    for (int i = 0; i < numOfCheckboxes.length; i++) {
      bool tempVal = numOfCheckboxes[i];
      if (tempVal == true) {
        try {
          double parsedNum = double.parse(amountList[i]);
          await dbHelper.insertIngredientToRecipe(
              recipe.id, ingredientList[i].id, parsedNum);
        } catch (error) {
          _showAlertDialog('Status', 'Please enter a value into amount field!');
        }
      }
    }
  }
}
