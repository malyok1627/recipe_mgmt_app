import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    // Define text style
    TextStyle titleText = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('My shopping list'),
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
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    
    return ListView.builder(
      itemCount: shoppingList.length,
      itemBuilder: (BuildContext context, int position) {
        numOfCheckboxes.add(false);
        return Card(
          color: Colors.white,
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
                  width: 125.0,
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
                  width: 125.0,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      shoppingList.values.elementAt(position).toString(),
                      style: titleStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
