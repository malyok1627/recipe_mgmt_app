import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';

class ShoppingListScreen extends StatefulWidget {
  final Map<String, dynamic> shoppingList;

  ShoppingListScreen(this.shoppingList);

  @override
  State<StatefulWidget> createState() {
    return ShoppingListScreenState(this.shoppingList);
  }
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  final Map<String, dynamic> shoppingList;

  ShoppingListScreenState(this.shoppingList);

  List<bool> numOfCheckboxes = List<bool>();
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // Define text style
    TextStyle titleText = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My shopping list',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.done),
            tooltip: 'Okay',
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ],
      ),
      body: getShoppingListView()
    );
  }

  int getAmountOfCheckboxes() {
    return shoppingList.length;
  }

  ListView getShoppingListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    
    return ListView.builder(
      itemCount: shoppingList.length,
      itemBuilder: (BuildContext context, int position) {
        numOfCheckboxes.add(false);
        return Card(
          color: Theme.of(context).selectedRowColor,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                // Checkbox
                Container(
                  width: 50.0,
                  child: Checkbox(
                    value: numOfCheckboxes[position],
                    onChanged: (bool val) {
                      boxStateChange(val, position);
                    },
                  ),
                ),

                // Ingredient name
                Container(
                  width: 140.0,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      shoppingList.keys.elementAt(position),
                      style: titleStyle,
                    ),
                  ),
                ),

                // Ingredient amount
                Container(
                  width: 100.0,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      getAndCorrectUnits(shoppingList, position),
                      style: titleStyle,
                    ),
                  ),
                ),

                // Ingredient unit
                // Container(
                //   width: 50.0,
                //   child: Padding(
                //     padding: EdgeInsets.all(5.0),
                //     child: Text(
                //       getIngredientUnit(shoppingList, position),
                //       style: titleStyle,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Correct units
  String getAndCorrectUnits(Map<String, dynamic> list, int pos) {
    String originalString = list.values.elementAt(pos).toString();
    int strLen = originalString.length;
    String correctedString = originalString.replaceRange(strLen-2, strLen, '');
    return correctedString;
  }

  // Get ingredient unit by ingredient ID
  Future<String> getIngredientUnit(Map<String, dynamic> list, int pos) async {
    String ingredientTitle = list.keys.elementAt(pos).toString();
    List<Map<String, dynamic>> ingerdientUnit = await dbHelper.getIngredientUnitByTitle(ingredientTitle);
    return ingerdientUnit.toString();
  }

  // Move back
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Monitor checkbox changes
  void boxStateChange(bool value, int position) {
    setState(() {
      numOfCheckboxes[position] = value;
    });
  }
}
