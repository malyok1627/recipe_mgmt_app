import 'package:flutter/material.dart';

class ShoppingListScreen extends StatefulWidget {
  final String appBarTitle;
  final Map<String, dynamic> shoppingList;

  ShoppingListScreen(this.shoppingList, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ShoppingListScreenState(this.shoppingList, this.appBarTitle);
  }
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  String appBarTitle;
  final Map<String, dynamic> shoppingList;

  // Used for text validation
  final _formKey = GlobalKey<FormState>();
  List<bool> numOfCheckboxes = List<bool>();

  ShoppingListScreenState(this.shoppingList, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    // Define text style
    TextStyle titleText = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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

  ListView getShoppingListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: shoppingList.length,
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
