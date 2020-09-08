
import 'package:flutter/material.dart';
import 'package:whatsapp/SplashScreen.dart';

import 'Telas/Login.dart';
import 'RouteGenerate.dart';
import 'package:whatsapp/RouteGenerate.dart';

void main() {

  //Color(0xff075E54)
  //Color(0xff25D366)
  runApp(MaterialApp(
    home: SplashScreen(),
    theme: ThemeData(
      primaryColor: Colors.deepPurpleAccent,
      accentColor: Colors.deepPurpleAccent
    ),
    initialRoute: "/",
    onGenerateRoute:RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}