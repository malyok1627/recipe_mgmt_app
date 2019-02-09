import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:recipe_mgmt_app/models/measurementUnit.dart';
import 'package:recipe_mgmt_app/screens/ingredientScreen.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class RecipeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecipeScreenState();
  }
}

class RecipeScreenState extends State<RecipeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Ingredient> ingredientList;
  int countIngredients = 0;

  // Value relevant for the Title
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe"),
      ),
      body: Column(
        children: <Widget>[
          // List of all Ingredients
          Expanded(
            child: getIngredientListView(),
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
                  debugPrint("Save button pressed");
                });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new Ingredient!
          Ingredient newIngredient = Ingredient('', null);
          // Add it to the list of ingredients for this recipe!
          // TODO
          // recipe.addNewIngredient(newIngredient);
          navigateToNewUnit(newIngredient);
        },
        tooltip: "Add Ingredient",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getIngredientListView() {
    TextStyle titleText = Theme.of(context).textTheme.title;

    return ListView.builder(
      itemCount: countIngredients,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 10.0,
          margin:
              EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              // Text
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  this.ingredientList[position].name,
                  style: titleText,
                ),
              ),

              TextFormField(
                controller: amountController,
                style: titleText,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  } else {
                    //updateName();
                    print('$value');
                  }
                },
                decoration: InputDecoration(
                  labelText: "Amount",
                  labelStyle: titleText,
                  contentPadding:
                      EdgeInsets.only(left: 20, bottom: 15.0, top: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              // Delete Icon
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
                child: GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    debugPrint("Unit deleted!");
                    //_delete(context, measurementUnitList[position], position);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    // return ListView.builder(
    //   itemCount: countIngredients,
    //   itemBuilder: (BuildContext context, int position) {
    //     return Card(
    //         color: Colors.white,
    //         elevation: 2.0,
    //         child: Row(
    //           children: <Widget>[
    //             Column(
    //               children: <Widget>[
    //                 // Upper part of a card - Ingredient name
    //                 Padding(
    //                   padding: EdgeInsets.only(left: 10.0, right: 10.0),
    //                   child: Text(
    //                     "Ingredient name",
    //                     style: titleText,
    //                   ),
    //                 ),

    //                 // Lower part of a card - TextField, DropDown, Icon
    //                 Row(
    //                   children: <Widget>[
    //                     // TextField
    //                     Padding(
    //                       padding: EdgeInsets.all(10.0),
    //                       child: TextField(
    //                         controller: amountController,
    //                         style: titleText,
    //                         onChanged: (value) {
    //                           debugPrint("The value changed to: $value");
    //                         },
    //                       ),
    //                     ),

    //                     // DropDown Menu
    //                     // ListTile(
    //                     //   title: DropdownButton(
    //                     //     items: _measuringUnits,
    //                     //     style: titleText,
    //                     //     onChanged: (chosenValue) {
    //                     //       setState(() {
    //                     //         debugPrint("User selected $chosenValue");
    //                     //       });
    //                     //     },
    //                     //   ),
    //                     // ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ));
    //   },
    // );
  }

  // Navigation function
  void navigateToNewUnit(Ingredient ingredient) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return IngredientScreen(ingredient);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // Update ListView
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
    dbFuture.then((database) {
      Future<List<Ingredient>> ingredientListFuture =
          databaseHelper.getIngredientList();
      ingredientListFuture.then((ingredientList) {
        setState(() {
          this.ingredientList = ingredientList;
          this.countIngredients = ingredientList.length;
        });
      });
    });
  }
}
