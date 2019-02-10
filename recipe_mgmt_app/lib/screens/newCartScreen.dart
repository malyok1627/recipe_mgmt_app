import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/cart.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class NewCartScreen extends StatefulWidget {
  final String appBarTitle;
  final Cart cart;

  NewCartScreen(this.cart, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NewCartScreenState(this.cart, this.appBarTitle);
  }
}

class NewCartScreenState extends State<NewCartScreen> {
  String appBarTitle;
  Cart cart;

  NewCartScreenState(this.cart, this.appBarTitle);

  // Used for text validation
  final _formKey = GlobalKey<FormState>();
  // Value relevant for cart name
  TextEditingController nameController = TextEditingController();
  // Initialize DB helper
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // Define text style
    TextStyle titleText = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Cart name - TextField
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
              child: TextFormField(
                controller: nameController,
                style: titleText,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  } else {
                    updateName();
                    print('$value');
                  }
                },
                decoration: InputDecoration(
                  labelText: "Cart name",
                  labelStyle: titleText,
                  contentPadding:
                      EdgeInsets.only(left: 20, bottom: 15.0, top: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            // Save button
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Colors.black,
                child: Text(
                  "Save",
                  textScaleFactor: 1.4,
                ),
                elevation: 10.0,
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      _save();
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // Update name of Cart object
  void updateName() {
    cart.name = nameController.text;
  }

  // Save cart to DB
  void _save() async {
    moveToLastScreen();

    // Add to DB table
    int result = await dbHelper.insertCart(cart);

    if (result != 0) {
      _showAlertDialog('Status', 'Cart Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Cart');
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
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
}

}