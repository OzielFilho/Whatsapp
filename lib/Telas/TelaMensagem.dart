import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp/model/ListConversas.dart';
import 'package:whatsapp/model/Mensagem.dart';
import 'package:whatsapp/model/Usuario.dart';

class TelaMensagem extends StatefulWidget {
  Usuario contato;
  TelaMensagem(this.contato);

  @override
  _TelaMensagemState createState() => _TelaMensagemState();
}

class _TelaMensagemState extends State<TelaMensagem> {
  TextEditingController _controllerMensagem = TextEditingController();
  String _idUser;
  String _idUserDestinatario;
  Firestore db = Firestore.instance;
  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUser = _idUser;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";
      _salvarMensagem(_idUser, _idUserDestinatario, mensagem);
      _salvarMensagem(_idUserDestinatario, _idUser, mensagem);
      _salvarConversa(mensagem);
    }
  }

  _salvarConversa(Mensagem msg) {
    //salvar remetente
    ListConversas cRemetente = ListConversas();
    cRemetente.idRemetente = _idUser;
    cRemetente.idDestinatario = _idUserDestinatario;
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.contato.nome;
    cRemetente.foto = widget.contato.urlImagem;
    cRemetente.tipo = msg.tipo;
    cRemetente.salvar();

    //Salvar destinatario
    ListConversas cDestinatario = ListConversas();
    cDestinatario.idRemetente = _idUserDestinatario;
    cDestinatario.idDestinatario = _idUser;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.contato.nome;
    cDestinatario.foto = widget.contato.urlImagem;
    cDestinatario.tipo = msg.tipo;
    cDestinatario.salvar();
  }

  _recuperarDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuario = await auth.currentUser();
    _idUser = usuario.uid;
    _idUserDestinatario = widget.contato.idUsuario;
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    await db
        .collection("mensagens")
        .document(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());
    _controllerMensagem.clear();
  }

  @override
  void initState() {
    _recuperarDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 8),
            child: TextField(
                // Caixa de texto para a senha
                controller:
                    _controllerMensagem, // - Armazena oq o usuario digita
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                    hintText: "Digite a mensagem",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: IconButton(
                        icon: Icon(Icons.camera_alt), onPressed: () {}))),
          ),
        ),
        FloatingActionButton(
            backgroundColor: Colors.deepPurpleAccent,
            child: Icon(Icons.send, color: Colors.white),
            mini: true,
            onPressed: () {
              _enviarMensagem();
            })
      ]),
    );
    var stream = StreamBuilder(
        stream: db
            .collection("mensagens")
            .document(_idUser)
            .collection(_idUserDestinatario)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(children: <Widget>[CircularProgressIndicator()]),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot querySnapshot = snapshot.data;
              if (snapshot.hasError) {
                return Text("ERRO AO CARREGAR");
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, index) {
                      List<DocumentSnapshot> mensagens =
                          querySnapshot.documents.toList();
                      DocumentSnapshot item = mensagens[index];
                      double larguraContainer =
                          MediaQuery.of(context).size.width * 0.6;
                      Alignment alinhamento = Alignment.centerRight;
                      Color cor = Colors.deepPurpleAccent;
                      Color corTexto = Colors.white;
                      if (_idUser != item["IdUsuario"]) {
                        cor = Colors.deepPurple;
                        alinhamento = Alignment.centerLeft;
                      }

                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                              width: larguraContainer,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: cor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: item["tipo"] == "texto"
                                  ? Text(
                                      item["mensagem"],
                                      style: TextStyle(
                                          color: corTexto, fontSize: 15),
                                    )
                                  : Text("p")),
                        ),
                      );
                    },
                  ),
                );
              }
              break;
          }
        });

    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
             ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                widget.contato.nome,
                style: TextStyle(color: Colors.white),
              ),
            ),
            onLongPress: () {
              print("Tocou");
            },
          ),
        ]),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: widget.contato.urlImagem != null
                      ? NetworkImage(widget.contato.urlImagem)
                      : AssetImage("assets/images/usuario.png"),
                  fit: BoxFit.cover)),
          child: SafeArea(
              child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      stream,
                      caixaMensagem,
                    ],
                  )))),
    );
  }
}
