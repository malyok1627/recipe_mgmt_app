import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/screens/ingredientScreen.dart';

class RecipeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecipeScreenState();
  }
}

class RecipeScreenState extends State<RecipeScreen> {
  int countIngredients = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe"),
      ),
      body: getIngredientListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new Ingredient!
          debugPrint("FAB pressed");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return IngredientScreen();
          }));
        },
        tooltip: "Add Ingredient",
        child:  Icon(Icons.add),
      ),
    );
  }

  ListView getIngredientListView() {
    TextStyle titleText = Theme.of(context).textTheme.title;

    // Values relevat for the input
    TextEditingController amountController = TextEditingController();

    // Variable used in drop down menu. Here measuring units of an
    // ingredient should appear
    List _measuringUnits = ["g", "each"];

    return ListView.builder(
      itemCount: countIngredients,
      itemBuilder: (BuildContext context, int position) {
        return Card(
            color: Colors.white,
            elevation: 2.0,
            child: Column(
              children: <Widget>[
                // Upper part of a card - Ingredient name
                Padding(
                  padding: EdgeInsets.only(left:10.0, right: 10.0),
                  child: Text("Ingredient name", style: titleText,),
                ),

                // Lower part of a card - TextField, DropDown, Icon
                Row(
                  children: <Widget>[
                    // TextField
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: amountController,
                        style: titleText,
                        onChanged: (value) {
                          debugPrint("The value changed to: $value");
                        },
                      ),
                    ),

                    // DropDown Menu
                    ListTile(
                      title: DropdownButton(
                        items: _measuringUnits,
                        style: titleText,
                        onChanged: (chosenValue) {
                          setState(() {
                            debugPrint("User selected $chosenValue");
                          });
                        },
                      ),
                    ),

                    // Delete Icon
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: GestureDetector(
                        child: Icon(Icons.delete),
                        onTap: () {
                          debugPrint("Ingredient deleted!");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}
