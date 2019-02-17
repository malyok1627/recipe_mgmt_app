import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:recipe_mgmt_app/screens/cartListScreen.dart';
import 'package:recipe_mgmt_app/screens/recipeScreen.dart';
import 'package:recipe_mgmt_app/screens/ingredientScreen.dart';

void main() => runApp(RecipeOrganizerApp());

class RecipeOrganizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shopping List Manager",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColorDark: Color.fromRGBO(86, 0, 39, 1.0),
        selectedRowColor: Color.fromRGBO(255, 233, 125, 1.0),
        brightness: Brightness.light,
      ),
      home: CartListScreen(),
    );
  }

}
