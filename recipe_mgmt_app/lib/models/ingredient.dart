
class Ingredient {
  int _id;
  String _name;
  String _unitName;

  // Constructors
  Ingredient(this._name, this._unitName);
  Ingredient.withId(this._id, this._name, this._unitName);

  // Getters
  int get id => _id;
  String get name => _name;
  String get unitName => _unitName;

  // Setters
  set name(String newName) {
    if (newName.length <= 25) {
      this._name = newName;
    }
  }
  set unitName(String newUnitName) {
    this._unitName = newUnitName;
  }

  // Convert a node object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map["ingredientId"] = _id;
    }
    map["ingredientName"] = _name;
    map["ingredientUnit"] = _unitName;

    return map;
  }

  // Extract a node object from a map object
  Ingredient.fromMapObject(Map<String, dynamic> map) {
    this._id = map["ingredientId"];
    this._name = map["ingredientName"];
    this._unitName = map["ingredientUnit"];
  }
}