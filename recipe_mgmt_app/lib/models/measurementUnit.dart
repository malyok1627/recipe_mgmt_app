class MeasurementUnit {
  int _id;
  String _name;

  // Constructors
  MeasurementUnit(this._name);
  MeasurementUnit.withId(this._id, this._name);

  // Getters
  int get id => _id;
  String get name => _name;

  // Setters
  set name(String newName) {
    if (newName.length <= 20) {
      this._name = newName;
    }
  }

  // Convert a Node object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map["id"] = _id;
    }
    map["name"] = _name;

    return map;
  }

  // Extract a node object from a map object
  MeasurementUnit.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._name = map["name"];
  }
}