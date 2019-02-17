import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/cart.dart';
import 'package:recipe_mgmt_app/screens/cartScreen.dart';
import 'package:recipe_mgmt_app/screens/newCartScreen.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: getCartListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Cart newCart = Cart('');
          navigateToNewCart(newCart, 'Add Cart');
        },
        tooltip: 'Add New Cart',
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Theme.of(context).selectedRowColor,
      ),
    );
  }

  ListView getCartListView() {
		return ListView.builder(
			itemCount: countCarts,
			itemBuilder: (BuildContext context, int position) {
				return Card(
					color: Theme.of(context).selectedRowColor,
          //margin: EdgeInsets.all(10.0),
					elevation: 4.0,
					child: ListTile(
						title: Text(
              this.cartList[position].name, 
              style: Theme.of(context).textTheme.title,
            ),
						trailing: GestureDetector(
							child: Icon(Icons.delete, color: Colors.black,),
							onTap: () {
								_delete(context, cartList[position]);
							},
						),
        		onTap: () {
							navigateToCart(this.cartList[position], 'Edit Cart');
						},
					),
				);
			},
    );
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
		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
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

  // Navigate to New Cart
  void navigateToNewCart(Cart newCart, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NewCartScreen(newCart, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  // Navigate to Existing Cart
  void navigateToCart(Cart cart, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return CartScreen(cart, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

}