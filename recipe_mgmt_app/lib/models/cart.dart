
class Cart {
  int _id;
  String _name;

  // Constructors
  Cart(this._name);
  Cart.withId(this._id, this._name);

  // Getters
  int get id => _id;
  String get name => _name;

  // Setters
  set name(String newName) {
    if (newName.length <= 40) {
      this._name = newName;
    }
  }

  // Convert a node object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map["cartId"] = _id;
    }
    map["cartName"] = _name;

    return map;
  }

  // Extract a node object from a map object
  Cart.fromMapObject(Map<String, dynamic> map) {
    this._id = map["cartId"];
    this._name = map["cartName"];
  }
}