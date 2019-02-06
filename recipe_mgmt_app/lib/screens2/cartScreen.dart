import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> {
  //int countRecipes = 0;

  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Cart"),
      ),
      body: //getRecipesListView(),
        ///
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.yellow,
                    elevation: 2.0,
                    child: ListTile(
                      title: Text("Dummy recipe"),
                      trailing: GestureDetector(
                        child: Icon(Icons.remove_circle, color: Colors.black),
                        onTap: () {
                          debugPrint("Recipe deleted!");
                        },
                      ),
                      onTap: () {
                        debugPrint("Recipe clicked!");
                      },
                    ),
                  ),
                  FlatButton(
                    child: Image.network("https://i.ytimg.com/vi/8kNE4XNIQH4/hqdefault.jpg"),
                    onPressed: () {
                      debugPrint("Recipe clicked!");
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        ///
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     debugPrint("FAB pressed!");
      //   },
      //   tooltip: "Add Cart",
      //   child: Icon(Icons.add),
      // ),
    );
  }

  // ListView getRecipesListView() {
  //   return ListView.builder(
  //     itemCount: countRecipes,
  //     itemBuilder: (BuildContext context, int position) {
  //       return Column(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.all(10),
  //             child: Column(
  //               children: <Widget>[
  //                 Card(
  //                   color: Colors.deepOrange,
  //                   elevation: 2.0,
  //                   child: ListTile(
  //                     title: Text("Dummy recipe"),
  //                     trailing: Icon(Icons.remove_circle, color: Colors.white),
  //                     onTap: () {
  //                       debugPrint("Recipe deleted!");
  //                     },
  //                   ),
  //                 ),
  //                 FlatButton(
  //                   child: Image.network("https://i.ytimg.com/vi/8kNE4XNIQH4/hqdefault.jpg"),
  //                   onPressed: () {
  //                     debugPrint("Recipe clicked!");
  //                   },
  //                 )
  //               ],
  //             ),
  //           ),
  //           Divider(),
  //         ],
  //       );
  //     },
  //   );
  // }
}
