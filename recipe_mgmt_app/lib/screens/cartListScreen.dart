import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/cart.dart';
import 'package:recipe_mgmt_app/screens/cartScreen.dart';
import 'package:recipe_mgmt_app/screens/newCartScreen.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:sqflite/sqflite.dart';

class CartListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartListScreenState();
  }
}

class CartListScreenState extends State<CartListScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Cart> cartList;
  int countCarts = 0;

  @override
  Widget build(BuildContext context) {
    if (cartList == null) {
      cartList = List<Cart>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping List Manager',
          //style: TextStyle(fontWeight: FontWeight.bold),
          //style: Theme.of(context).textTheme.title,
          //style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(getIconBasedOnTheme()),
            tooltip: 'Change Theme',
            onPressed: () {
              changeBrightness();
            },
          ),
        ],
      ),
      body: getCartListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Cart newCart = Cart('');
          navigateToNewCart(newCart, 'Add Cart');
        },
        tooltip: 'Add New Cart',
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).indicatorColor,
        foregroundColor: Theme.of(context).selectedRowColor,
      ),
    );
  }

  ListView getCartListView() {
    return ListView.builder(
      itemCount: countCarts,
      itemBuilder: (BuildContext context, int position) {
        return Card(
            //color: Theme.of(context).primaryColor,
            elevation: 4.0,
            child: Row(
              children: <Widget>[
                // Cart name
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width-80,
                    child: GestureDetector(
                      child: Text(
                        this.cartList[position].name,
                        style: Theme.of(context).textTheme.title,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      onTap: () {
                        navigateToCart(this.cartList[position], 'Edit');
                      },
                    ),
                  )
                  
                ),

                Spacer(),

                // Delete icon
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: Icon(Icons.delete,
                        color: Theme.of(context).selectedRowColor),
                    onTap: () {
                      _delete(context, cartList[position]);
                    },
                  ),
                )
              ],
            ));
      },
    );
  }

  IconData getIconBasedOnTheme() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Icons.brightness_5;
    } else {
      return Icons.brightness_3;
    }
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  // Update List View
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Cart>> cartListFuture = dbHelper.getCartList();
      cartListFuture.then((cartList) {
        setState(() {
          this.cartList = cartList;
          this.countCarts = cartList.length;
        });
      });
    });
  }

  // Delete Cart
  void _delete(BuildContext context, Cart cart) async {
    int result = await dbHelper.deleteCart(cart.id);
    if (result != 0) {
      _showSnackBar(context, 'Cart Deleted Successfully');
      updateListView();
    }
  }

  // Snack bar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // Navigate to New Cart
  void navigateToNewCart(Cart newCart, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewCartScreen(newCart, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // Navigate to Existing Cart
  void navigateToCart(Cart cart, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CartScreen(cart, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
}
