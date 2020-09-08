import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whatsapp/Telas/Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.deepPurple,
          padding: EdgeInsets.all(60),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            Image.asset("assets/images/logo.png",
                width: 350, height: 280, fit: BoxFit.fitHeight),
            
                Text("Desenvolvido por Oziel Filho",style: TextStyle(color: Colors.white),)],
            
          ))),
    );
  }
}
