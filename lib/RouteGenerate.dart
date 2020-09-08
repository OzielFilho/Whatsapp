import 'package:flutter/material.dart';
import 'package:whatsapp/Config.dart';
import 'package:whatsapp/SplashScreen.dart';
import 'package:whatsapp/Telas/Cadastro.dart';
import 'package:whatsapp/Telas/Login.dart';
import 'package:whatsapp/Telas/TelaMensagem.dart';
import 'Telas/Home.dart';

class RouteGenerator{
  static const String HOME_ROTA = "/home";
  static const String LOGIN_ROTA = "/login";
  static const String CADASTRO_ROTA = "/cadastro";
  static const String INICIO_ROTA = "/";
  static const String CONFIGURACA_ROTA = "/configuracao";
  static const String TELA_MENSAGEM_ROTA = "/tela_mensagem";
  static const String SPLASH_TELA = "/splash";

  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case INICIO_ROTA:
        return MaterialPageRoute(
          builder: (context) => Login()
          );
      case HOME_ROTA:
        return MaterialPageRoute(
          builder: (context) => Home()
          );
      case LOGIN_ROTA:
        return MaterialPageRoute(
          builder: (context) => Login()
          );
      case CADASTRO_ROTA:
        return MaterialPageRoute(
          builder: (context) => Cadastro()
          );
      case CONFIGURACA_ROTA:
         return MaterialPageRoute(
          builder: (context) => Config()
          );
      case TELA_MENSAGEM_ROTA:
         return MaterialPageRoute(
          builder: (context) => TelaMensagem(args)
          ); 
      case SPLASH_TELA:
         return MaterialPageRoute(
          builder: (context) => SplashScreen()
          );  
      default:
        _erroRota();   
    }
  }
  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(title:Text("Tela nao encontrada")),
          body: Center(
            child:Text("Tela nao encontrada"),
          ),
        );
      }
      
      );
  }
}