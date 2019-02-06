class Ingredient {
  int _id;
  String _name;
  List<String> _measurementUnits;


  // Constructors
  Ingredient(this._name, this._measurementUnits);
  Ingredient.withId(this._id, this._name, this._measurementUnits);

  // Getters
  int get id => _id;
  String get name => _name;
  List<String> get measurementUnits => _measurementUnits;

  // Setters
  set name(String newName) {
    if (newName.length <= 25) {
      this._name = newName;
    }
  }
  set measurementUnits(List<String> newMeasurementUnitsList) {
    this._measurementUnits = newMeasurementUnitsList;
  }

  // Add new measurement unit to a list
  addNewMeasurementUnit(String newUnit) {
    // Get current list of units
    List<String> temporaryList = measurementUnits;

    // Add one more intsance to the list
    temporaryList.add(newUnit);
  }

  // Convert a node object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(_id != null) {
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