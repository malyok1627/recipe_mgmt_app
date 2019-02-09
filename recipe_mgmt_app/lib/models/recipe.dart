
class Recipe {
  int _id;
  String _name;
  String _category;

  // Constructors
  Recipe(this._name, this._category);
  Recipe.withId(this._id, this._name, this._category);

  // Getters
  int get id => _id;
  String get name => _name;
  String get unitName => _category;

  // Setters
  set name(String newName) {
    if (newName.length <= 25) {
      this._name = newName;
    }
  }
  set unitName(String newCategory) {
    this._category = newCategory;
  }

  // Convert a node object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map["recipeId"] = _id;
    }
    map["recipeName"] = _name;
    map["recipeCategory"] = _category;

    return map;
  }

  // Extract a node object from a map object
  Recipe.fromMapObject(Map<String, dynamic> map) {
    this._id = map["recipeId"];
    this._name = map["recipeName"];
    this._category = map["recipeCategory"];
  }
}