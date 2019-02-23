import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:recipe_mgmt_app/screens/cartListScreen.dart';

void main() => runApp(RecipeOrganizerApp());

class RecipeOrganizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => _buildTheme(brightness),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: "Shopping List Manager",
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: CartListScreen(),
          );
        });
    // return MaterialApp(
    //   title: "Shopping List Manager",
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     primarySwatch: Colors.amber,
    //     primaryColorDark: Color.fromRGBO(86, 0, 39, 1.0),
    //     selectedRowColor: Color.fromRGBO(255, 233, 125, 1.0),
    //     brightness: Brightness.light,
    //   ),
    //   home: CartListScreen(),
    // );
  }

  ThemeData _buildTheme(Brightness brightness) {
    return brightness == Brightness.dark
      ? ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          backgroundColor: Color.fromRGBO(35, 47, 52, 1),
          selectedRowColor: Colors.white,
          // Floating action button color
          indicatorColor: Color.fromRGBO(249, 170, 51, 1),
          // Checkbox color
          toggleableActiveColor: Color.fromRGBO(249, 170, 51, 1),
        )
      : ThemeData.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
          backgroundColor: Colors.white,
          selectedRowColor: Colors.black,
          primaryColor: Color.fromRGBO(249, 170, 51, 1),
          // Floating action button color
          indicatorColor: Color.fromRGBO(249, 170, 51, 1),
          // Checkbox color
          toggleableActiveColor: Colors.black,

          //primaryColorDark: Colors.brown   
          // Scaffold color       
          //scaffoldBackgroundColor: Color.fromRGBO(249, 170, 51, 1),
        );
  }
}
