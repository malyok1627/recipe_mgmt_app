import 'package:flutter/material.dart';
import 'package:recipe_mgmt_app/models/cart.dart';
import 'package:recipe_mgmt_app/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class CartScreen extends StatefulWidget {
  final String appBarTitle;
  final Cart cart;

  CartScreen(this.cart, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return CartScreenState(this.cart, this.appBarTitle);
  }
}

class CartScreenState extends State<CartScreen> {
  String appBarTitle;
  Cart cart;

  CartScreenState(this.cart, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }

}