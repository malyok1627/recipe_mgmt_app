import 'package:recipe_mgmt_app/models/measurementUnit.dart';

class Ingredient {
  int _id;
  String _name;
  List<MeasurementUnit> _measurementUnits;

  // Constructors
  Ingredient(this._name, this._measurementUnits);
  Ingredient.withId(this._id, this._name, this._measurementUnits);

  // Getters
  int get id => _id;
  String get name => _name;
  List<MeasurementUnit> get measurementUnits => _measurementUnits;

  // Setters
  set name(String newName) {
    if (newName.length <= 25) {
      this._name = newName;
    }
  }
  set measurementUnits(List<MeasurementUnit> newMeasurementUnitsList) {
    this._measurementUnits = newMeasurementUnitsList;
  }

  // Add new measurement unit to a list
  addNewMeasurementUnit(MeasurementUnit newUnit) {
    // Add one more intsance to the list
    // for (int i=0; i<measurementUnits.length; i++) {
    //   MeasurementUnit obj = measurementUnits[i];
    //   String name = obj.name;
    //   int id = obj.id;
    //   print("name: $name, id: $id");
    // }
    measurementUnits.add(newUnit);
    // print("after insertion");
    // for (int i=0; i<measurementUnits.length; i++) {
    //   MeasurementUnit obj = measurementUnits[i];
    //   String name = obj.name;
    //   int id = obj.id;
    //   print("name: $name, id: $id");
    // }
  }
  // Delete measurement unit from a list
  deleteMeasurementUnit(int position) {
    // Delete an instance from a list
    // for (int i=0; i<measurementUnits.length; i++) {
    //   MeasurementUnit obj = measurementUnits[i];
    //   String name = obj.name;
    //   int id = obj.id;
    //   print("name: $name, id: $id");
    // }
    measurementUnits.removeAt(position);
    // print("after deletion");
    // for (int i=0; i<measurementUnits.length; i++) {
    //   MeasurementUnit obj = measurementUnits[i];
    //   String name = obj.name;
    //   int id = obj.id;
    //   print("name: $name, id: $id");
    // }

  }

  // Convert a node object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map["id"] = _id;
    }
    map["name"] = _name;
    map["measurementUnits"] = _measurementUnits;

    return map;
  }

  // Extract a node object from a map object
  Ingredient.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._name = map["name"];
    this._measurementUnits = map["measurementUnits"];
  }
}