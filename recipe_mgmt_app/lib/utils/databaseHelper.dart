import 'package:recipe_mgmt_app/models/ingredient.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_mgmt_app/models/measurementUnit.dart';

class DatabaseHelper {
  // Singleton helper
  static DatabaseHelper _databaseHelper;
  static Database _database;

  // Define MeasurementUnit table and columns
  String measurementUnitsTable = 'measurementUnitsTable';
  String unitColId = 'id';
  String unitColName = 'name';
  // Define Ingredient table and column
  String ingredientsTable = 'ingredientsTable';
  String ingredientColId = 'id';
  String ingredientColName = 'name';
  String ingredientUnits = 'units';


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
    String path = directory.path + "carts.db";

    // Open/create a db at a give path
    var cartsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return cartsDatabase;
  }

  void addIngredientsTable() async {
    await _database.transaction((txn) async {
      await txn.execute(
        'CREATE TABLE $ingredientsTable ('
        '$ingredientColId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$ingredientColName TEXT,'
        '$ingredientUnits INTEGER,'
        'FOREIGN KEY ($ingredientUnits) REFERENCES $measurementUnitsTable ($unitColId) );'
      );
    });
  }

  // Create DB
  void _createDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $measurementUnitsTable ('
      '$unitColId INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$unitColName TEXT );'
    );
  }

  // CRUD operations
  // MeasurementUnit
  // Fetch
  Future<List<Map<String, dynamic>>> getMeasurementUnitMapList() async {
    Database db = await this.database;
    var result = await db.query(measurementUnitsTable); 
    //var result = await db.query(measurementUnitsTable, orderBy: '$unitColName ASC');
    return result;
  }
  // Insert
  Future<int> insertMeasurementUnit(MeasurementUnit unit) async {
    Database db = await this.database;
    var result = await db.insert(measurementUnitsTable, unit.toMap());
    return result;
  }
  // Update
  Future<int> updateMeasurementUnit(MeasurementUnit unit) async {
    var db = await this.database;
    var result = await db.update(measurementUnitsTable, unit.toMap(), where: '$unitColId = ?', whereArgs: [unit.id]);
    return result;
  }
  // Delete
  Future<int> deleteMeasurementUnit(int id) async {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $measurementUnitsTable WHERE $unitColId = $id');
    return result;
  }
  // Number of objects in a table
  Future<int> getCountMeasurementUnit() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $measurementUnitsTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
  // Get "Map List" and convert to "Ingredients List"
  Future<List<MeasurementUnit>> getMeasurementUnitList() async {
    // Get Map List from DB
    var unitMapList = await getMeasurementUnitMapList();
    int count = unitMapList.length;

    List<MeasurementUnit> measurementUnitList = List<MeasurementUnit>();
    for (int i=0; i<count; i++) {
      measurementUnitList.add(MeasurementUnit.fromMapObject(unitMapList[i]));
    }
    return measurementUnitList;
  }

  // Ingredient
  // Fetch
  Future<List<Map<String, dynamic>>> getIngredientMapList() async {
    Database db = await this.database;
    var result = await db.query(ingredientsTable, orderBy: '$ingredientColName ASC');
    return result;
  }
  // Insert
  Future<int> insertIngredient(Ingredient ingredient) async {
    Database db = await this.database;
    var result = await db.insert(ingredientsTable, ingredient.toMap());
    return result;
  }

  // Get "Map List" and convert to "Ingredients List"
  Future<List<Ingredient>> getIngredientList() async {
    // Get Map List from DB
    var ingredientMapList = await getIngredientMapList();
    int count = ingredientMapList.length;

    List<Ingredient> ingredientList = List<Ingredient>();
    for (int i=0; i<count; i++) {
      ingredientList.add(Ingredient.fromMapObject(ingredientMapList[i]));
    }
    return ingredientList;
  }
}