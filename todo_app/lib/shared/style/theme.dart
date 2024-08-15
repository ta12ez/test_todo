import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/shared/style/color.dart';

ThemeData lighttheme = ThemeData(
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30),
      bodySmall:TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16,height: 1.3),
    ),

    primarySwatch: defaultColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Jannah',
    appBarTheme: const AppBarTheme(

      iconTheme: IconThemeData(color: Colors.black),
      //backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
          fontFamily: 'Jannah',
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      backgroundColor: Colors.white,
      elevation: 0.0,
    ));
