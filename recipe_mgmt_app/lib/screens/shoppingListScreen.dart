import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';

class ShoppingListScreen extends StatefulWidget {
  final List shoppingList;

  ShoppingListScreen(this.shoppingList);

  @override
  State<StatefulWidget> createState() {
    return ShoppingListScreenState(this.shoppingList);
  }
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  // [0] - ingredient name and amount
  // [1] - ingredient name and unit
  final List shoppingList;

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
    return shoppingList[0].length;
  }

  ListView getShoppingListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    
    return ListView.builder(
      itemCount: shoppingList[0].length,
      itemBuilder: (BuildContext context, int position) {
        numOfCheckboxes.add(false);
        return Card(
          color: Theme.of(context).selectedRowColor,
          elevation: 4.0,
          child: ListTile(
            // Checkbox
            leading: Checkbox(
              value: numOfCheckboxes[position],
              onChanged: (bool val) {
                boxStateChange(val, position);
              },
            ),
            // Ingredient name
            title: Text(
              shoppingList[0].keys.elementAt(position),
              style: titleStyle,
            ),
            trailing: Container(
              child: Column(
                children: <Widget>[
                  // Ingredient amount
                  Text(
                    getAndCorrectUnits(shoppingList[0], position),
                    style: titleStyle,
                  ),
                  // Ingredeint unit
                  Text(
                    shoppingList[1].values.elementAt(position),
                    style: titleStyle,
                  ),
                ],
              ),
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
