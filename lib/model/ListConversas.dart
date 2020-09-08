import 'package:cloud_firestore/cloud_firestore.dart';

class ListConversas {
  String _idRemetente;
  String _idDestinatario;

  String _nome;
  String _mensagem;
  String _foto;
  String _tipo;

  ListConversas();
   Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "idRemetente" : this.idRemetente,
      "idDestinatario" : this.idDestinatario,
      "nome":this.nome,
      "mensagem":this.mensagem,
      "foto":this.foto,
      "tipo":this.tipo,

      
    };
    return map;
  }

  salvar() async{
    Firestore db = Firestore.instance;
    await db.collection("conversas")
    .document(this.idRemetente)
    .collection("ultima conversa")
    .document(this.idDestinatario)
    .setData(this.toMap());
  }
  String get nome => _nome;
  set nome(String value) {
    _nome = value;
  } 

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get foto => _foto;

  set foto(String value) {
    _foto = value;
  }

  String get idRemetente => _idRemetente;

  set idRemetente(String value) {
    _idRemetente = value;
  }
  String get idDestinatario => _idDestinatario;

  set idDestinatario(String value) {
    _idDestinatario = value;
  }
  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }




}
