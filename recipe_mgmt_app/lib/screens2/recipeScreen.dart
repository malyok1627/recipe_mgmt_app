import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
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

  static var _categories = ["Dessert", "Main Dish", "Soup"];

  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(ingredientList == null) {
      ingredientList = List<Ingredient>();
      updateListView();
    }

    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Recipe"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            // Image
            // Container(
            //   width: 200,
            //   height: 200,
            //   child: Image.network("https://i.ytimg.com/vi/8kNE4XNIQH4/hqdefault.jpg"),
            // ),
            

            // DropDownButton
            // ListTile(
            //   title: DropdownButton(
            //     items: _categories.map((String dropDownStringItem) {
            //       return DropdownMenuItem<String>(
            //         value: dropDownStringItem,
            //         child: Text(dropDownStringItem),
            //       );
            //     }).toList(),
            //     style: textStyle,
            //     value: "Dessert",
            //     onChanged: (valueChangedByUser) {
            //       setState(() {
            //         debugPrint("User selected $valueChangedByUser");
            //       });
            //     },
            //   ),
            // ),

            // Container
            // Text
            // Padding(
            //   padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            //   child: Row(
            //     children: <Widget>[
            //       Container(
            //         margin: EdgeInsets.only(left: 10, right: 20),
            //         child: Text(
            //           "Ingredient",
            //           style: textStyle,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: 10, right: 20),
            //         child: Text(
            //           "Amount",
            //           style: textStyle,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: 10, right: 10),
            //         child: Text(
            //           "Unit",
            //           style: textStyle,
            //         ),
            //       ),
            //     ],
            //   )),
            // Horizontal line
            // Padding(
            //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
            //   child: Divider(
            //     color: Theme.of(context).secondaryHeaderColor,
            //     height: 8.0,
            //   ),
            // ),

            // List of all ingredients in the recipe
            Expanded(
              child: getIngredientsListView(),
            ),

            // Button to add new Ingredient
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add new measurement unit",
                onPressed: () {
                  debugPrint("Add button pressed!");
                  navigateToNewIngredient("New Ingredient");
                },
              ),
            ),

            // Description
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint("Something changed in description");
                },
                decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Raised Button
            Padding(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text("Save", textScaleFactor: 1.5,),
                onPressed: () {
                  setState(() {
                    debugPrint("Save button clicked!");
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  ListView getIngredientsListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: countIngredients,
      itemBuilder: (BuildContext context, int position) {
        return Row(
          children: <Widget>[
            Text(this.ingredientList[position].name, style: titleStyle,),
            Text(this.ingredientList[position].measurementUnits[0], style: titleStyle,),
            GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                _delete(context, ingredientList[position]);
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToNewIngredient(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      //return IngredientScreen(title);
    }));
  }

  void _delete(BuildContext context, Ingredient ingredient) async {
    int result = await databaseHelper.deleteIngredient(ingredient.id);
    if(result != 0) {
      _showSnackBar(context, "Ingredient Deleted Succesfully!");
    }
    updateListView();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
		final Future<Database> dbFuture = databaseHelper.initallizeDatabase();
		dbFuture.then((database) {

			Future<List<Ingredient>> ingredientListFuture = databaseHelper.getIngredientList();
			ingredientListFuture.then((ingredientList) {
				setState(() {
				  this.ingredientList = ingredientList;
				  this.countIngredients = ingredientList.length;
				});
			});
		});
}

}
