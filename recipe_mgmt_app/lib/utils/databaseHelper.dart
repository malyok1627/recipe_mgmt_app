import 'package:recipe_mgmt_app/models/cart.dart';
import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:recipe_mgmt_app/models/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Singleton helper
  static DatabaseHelper _databaseHelper;
  static Database _database;

  // Define Ingredient table and columns
  String ingredientsTable = 'ingredientsTable';
  String ingredientColId = 'ingredientId';
  String ingredientColName = 'ingredientName';
  String ingredientColUnit = 'ingredientUnit';
  // Define Recipe table and columns
  String recipesTable = 'recipiesTable';
  String recipeColId = 'recipeId';
  String recipeColName = 'recipeName';
  String recipeColCategory = 'recipeCategory';
  // Define Cart table and columns
  String cartsTable = 'cartsTable';
  String cartColId = 'cartId';
  String cartColName = 'cartName';
  // Define Bridge table and columns
  // Bridge table from Recipe and Ingredient
  String brTableRecipeIngredient = 'recipeIngredientBrTable';
  String brTableRIColRecId = 'recipeId';
  String brTableRIColIngId = 'ingredientId';
  String brTableRIColAmount = 'amount';
  // Bridge table from Cart and Recipe
  String brTableCartRecipe = 'cartRecipeBrTable';
  String brTableCRColCartId = 'cartId';
  String brTableCRColRecId = 'recipeId';

  // Named constructor to create instance of DatabaseHelper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    // Ensure of singleton object
    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  // Getter
  Future<Database> get database async {
    if(_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    // Get directory path from both iOS and Android
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "/carts.db";
    print('$path');

    // Open/create a db at a give path
    var cartsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return cartsDatabase;
  }

  // Create DB
  void _createDb(Database db, int newVersion) async {
    await db.execute(
      // CREATE Table for Ingredients
      'CREATE TABLE $ingredientsTable ('
        '$ingredientColId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$ingredientColName TEXT,'
        '$ingredientColUnit TEXT);'
      // CREATE Table for Recipies
      'CREATE TABLE $recipesTable ('
        '$recipeColId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$recipeColName TEXT,'
        '$recipeColCategory TEXT);'
      // CREATE Table for Carts
      'CREATE TABLE $cartsTable ('
        '$cartColId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$cartColName TEXT);'
      // CREATE BRIDGE Table for Recipies&Ingredients
      'CREATE TABLE $brTableRecipeIngredient ('
        '$brTableRIColRecId INTEGER,'
        '$brTableRIColIngId INTEGER,'
        '$brTableRIColAmount REAL,'
        'FOREIGN KEY ($brTableRIColRecId) REFERENCES $recipesTable ($brTableRIColRecId) ON DELETE CASCADE,'
        'FOREIGN KEY ($brTableRIColIngId) REFERENCES $ingredientsTable ($brTableRIColIngId) ON DELETE CASCADE);'
      // CREATE BRIDGE Table for Carts&Recipies
      'CREATE TABLE $brTableCartRecipe ('
        '$brTableCRColCartId INTEGER,'
        '$brTableCRColRecId INTEGER,'
        'FOREIGN KEY ($brTableCRColCartId) REFERENCES $cartsTable ($brTableCRColCartId) ON DELETE CASCADE,'
        'FOREIGN KEY ($brTableCRColRecId) REFERENCES $recipesTable ($brTableCRColRecId) ON DELETE CASCADE);'
    );
  }

  //  CRUD operations for Ingredient
  // Fetch
  Future<List<Map<String, dynamic>>> getIngredientMapList() async {
    Database db = await this.database;
    var result = await db.query(ingredientsTable);
    //var result = await db.query(ingredientsTable, orderBy: '$ingredientColName ASC');
    return result;
  }
  // Insert
  Future<int> insertIngredient(Ingredient ingredient) async {
    Database db = await this.database;
    var result = await db.insert(ingredientsTable, ingredient.toMap());
    return result;
  }
  // Update
  Future<int> updateIngredient(Ingredient ingredient) async {
    var db = await this.database;
    var result = await db.update(ingredientsTable, ingredient.toMap(), where: '$ingredientColId = ?', whereArgs: [ingredient.id]);
    return result;
  }
  // Delete
  Future<int> deleteIngredient(int id) async {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $ingredientsTable WHERE $ingredientColId = $id');
    return result;
  }

  // Number of objects in a table
  Future<int> getCountIngredients() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $ingredientsTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get "Map List" and convert to "Ingredients List"
  Future<List<Ingredient>> getIngredientsList() async {
    // Get Map List from DB
    var ingredientMapList = await getIngredientMapList();
    int count = ingredientMapList.length;

    List<Ingredient> ingredientList = List<Ingredient>();
    for (int i=0; i<count; i++) {
      ingredientList.add(Ingredient.fromMapObject(ingredientMapList[i]));
    }
    return ingredientList;
  }

  //  CRUD operations for Recipe
  // Fetch
  Future<List<Map<String, dynamic>>> getRecipeMapList() async {
    Database db = await this.database;
    var result = await db.query(recipesTable);
    return result;
  }
  // Insert
  Future<int> insertRecipe(Recipe recipe) async {
    Database db = await this.database;
    var result = await db.insert(ingredientsTable, recipe.toMap());
    return result;
  }
  // Update
  Future<int> updateRecipe(Recipe recipe) async {
    var db = await this.database;
    var result = await db.update(ingredientsTable, recipe.toMap(), where: '$recipeColId = ?', whereArgs: [recipe.id]);
    return result;
  }
  // Delete
  Future<int> deleteRecipe(int id) async {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $recipesTable WHERE $recipeColId = $id');
    return result;
  }

  // Number of objects in a table
  Future<int> getCountRecipies() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $recipesTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get "Map List" and convert to "Recipes List"
  Future<List<Recipe>> getRecipesList() async {
    // Get Map List from DB
    var recipeMapList = await getRecipeMapList();
    int count = recipeMapList.length;

    List<Recipe> recipeList = List<Recipe>();
    for (int i=0; i<count; i++) {
      recipeList.add(Recipe.fromMapObject(recipeMapList[i]));
    }
    return recipeList;
  }

  //  CRUD operations for Cart
  // Fetch
  Future<List<Map<String, dynamic>>> getCartMapList() async {
    Database db = await this.database;
    var result = await db.query(cartsTable);
    return result;
  }
  // Insert
  Future<int> insertCart(Cart cart) async {
    Database db = await this.database;
    var result = await db.insert(ingredientsTable, cart.toMap());
    return result;
  }
  // Update
  Future<int> updateCart(Cart cart) async {
    var db = await this.database;
    var result = await db.update(ingredientsTable, cart.toMap(), where: '$cartColId = ?', whereArgs: [cart.id]);
    return result;
  }
  // Delete
  Future<int> deleteCart(int id) async {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $cartsTable WHERE $cartColId = $id');
    return result;
  }

  // Number of objects in a table
  Future<int> getCountCarts() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $cartsTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get "Map List" and convert to "Carts List"
  Future<List<Cart>> getCartsList() async {
    // Get Map List from DB
    var cartMapList = await getRecipeMapList();
    int count = cartMapList.length;

    List<Cart> cartList = List<Cart>();
    for (int i=0; i<count; i++) {
      cartList.add(Cart.fromMapObject(cartMapList[i]));
    }
    return cartList;
  }

  //  CRUD operations for recipeIngredientBrTable
  // Fetch
  Future<List<Map<String, dynamic>>> getRecipeIngredientList(int recipeId) async {
    Database db = await this.database;
    var result = await db.rawQuery(
      'SELECT * FROM $ingredientsTable '
      'WHERE $ingredientColId IN ( '
        'SELECT $ingredientColId FROM ( '
	        'SELECT * FROM $brTableRecipeIngredient WHERE '
	        '$brTableRIColRecId = $recipeId ) )');
    return result;
  }
  // Insert
  Future<int> insertIngredientToRecipe(int recipeId, int ingredientId, double amount) async {
    Database db = await this.database;
    var result = await db.rawInsert('INSERT INTO $brTableRecipeIngredient ('
      '$brTableRIColRecId, $brTableRIColIngId, $brTableRIColAmount) VALUES '
      '($recipeId, $ingredientId, $amount);');
    return result;
  }
  // Update
  Future<int> updateIngredientAmountInRecipe(int recipeId, int ingredientId, double amount) async {
    var db = await this.database;
    var result = await db.rawUpdate('UPDATE $brTableRecipeIngredient '
      'SET $brTableRIColAmount = $amount '
      'WHERE $brTableRIColRecId = $recipeId AND $brTableRIColIngId = $ingredientId');
    return result;
  }
  // Delete
  Future<int> deleteIngredientFromRecipe(int recipeId, int ingredientId) async {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $brTableRecipeIngredient '
      'WHERE $brTableRIColRecId = $recipeId AND $brTableRIColIngId = $ingredientId');
    return result;
  }
  // Get "Map List" and convert to "Ingredients List"
  Future<List<Ingredient>> getIngredientsInRecipeList(int recipeId) async {
    // Get Map List from DB
    var ingredientMapList = await getRecipeIngredientList(recipeId);
    int count = ingredientMapList.length;

    List<Ingredient> ingredientList = List<Ingredient>();
    for (int i=0; i<count; i++) {
      ingredientList.add(Ingredient.fromMapObject(ingredientMapList[i]));
    }
    return ingredientList;
  }

  // CRD operations for recipeIngredientBrTable
  // Fetch
  Future<List<Map<String, dynamic>>> getCartRecipeList(int cartId) async {
    Database db = await this.database;
    var result = await db.rawQuery(
      'SELECT * FROM $recipesTable '
      'WHERE $recipeColId IN ( '
        'SELECT $recipeColId FROM ( '
	        'SELECT * FROM $brTableCartRecipe WHERE '
	        '$brTableCRColCartId = $cartId ) )');
    return result;
  }
  // Insert
  Future<int> insertRecipeToCart(int cartId, int recipeId) async {
    Database db = await this.database;
    var result = await db.rawInsert('INSERT INTO $brTableCartRecipe ('
      '$brTableCRColCartId, $brTableCRColRecId) VALUES '
      '($cartId, $recipeId);');
    return result;
  }
  // Delete
  Future<int> deleteRecipeFromCart(int cartId, int recipeId) async {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $brTableRecipeIngredient '
      'WHERE $brTableCRColCartId = $cartId AND $brTableCRColRecId = $recipeId');
    return result;
  }
  // Get "Map List" and convert to "Ingredients List"
  Future<List<Recipe>> getRecipesInCartList(int cartId) async {
    // Get Map List from DB
    var recipeMapList = await getCartRecipeList(cartId);
    int count = recipeMapList.length;

    List<Recipe> recipeList = List<Recipe>();
    for (int i=0; i<count; i++) {
      recipeList.add(Recipe.fromMapObject(recipeMapList[i]));
    }
    return recipeList;
  }
}