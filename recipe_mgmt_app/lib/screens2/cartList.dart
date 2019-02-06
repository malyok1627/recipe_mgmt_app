import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/screens/cartScreen.dart';

class CartList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartListState();
  }
}

class CartListState extends State<CartList> {
  int countCarts = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RecipeOrganizer"),
      ),
      body: getCartListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB pressed!");
        },
        tooltip: "Add Cart",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getCartListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: countCarts,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.yellowAccent,
          elevation: 2.0,
          child: ListTile(
            title: Text("Dummy cart", style: titleStyle,),
            trailing: Icon(Icons.delete, color: Colors.black),
            onTap: () {
              debugPrint("Cart tapped!");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CartScreen();
              }));
            },
          ),
        );
      },
    );
  }
}