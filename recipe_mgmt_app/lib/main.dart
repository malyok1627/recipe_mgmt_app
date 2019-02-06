import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/screens/recipeScreen.dart';
import 'package:recipe_mgmt_app/screens/ingredientScreen.dart';
import 'package:recipe_mgmt_app/screens/newUnitScreen.dart';

void main() => runApp(RecipeOrganizerApp());

class RecipeOrganizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RecipeOrganizer",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        secondaryHeaderColor: Colors.red,
      ),
      home: RecipeScreen(),
    );
  }

}
