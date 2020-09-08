import 'package:flutter/material.dart';
class Mensagem{
  String _idUser;
  String _mensagem;
  String _tipo;
  String _urlImagem;

  Mensagem();
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "IdUsuario" : this.idUser,
      "mensagem" : this.mensagem,
      "urlImage" : this.urlImagem,
      "tipo" : this.tipo,      
    };
    return map;
  }
  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get  idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }
}