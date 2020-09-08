import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Tabs/Contatos.dart';

import 'package:whatsapp/model/Usuario.dart';

import '../RouteGenerate.dart';

class Conversas extends StatefulWidget {
  @override
  _ConversasState createState() => _ConversasState();
}

class _ConversasState extends State<Conversas> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  String _idUser;

  @override
  void initState() {
    super.initState();
    _recuperarDados();
  }

  Stream<QuerySnapshot> _adicionarListenerConversas() {
    final stream = db
        .collection(
            'conversas') // Controler de dados que vai ser adicionado no controller
        .document(_idUser)
        .collection("ultima conversa")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _recuperarDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuario = await auth.currentUser();
    _idUser = usuario.uid;
    _adicionarListenerConversas();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(children: <Widget>[
                Text("Carregando conversas"),
                CircularProgressIndicator()
              ]),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("ERRO AO CARREGAR");
            } else {
              QuerySnapshot querySnapshot =
                  snapshot.data; //Pega do snapshot todos os dados presentes
              List<DocumentSnapshot> mensagens = querySnapshot.documents
                  .toList(); // Recebe as mensagens do querySnapshot e coloca em uma lista mensagens
              if (querySnapshot.documents.length == 0) {
                return Center(
                  child: Column(
                    children: [
                      Text("\nVoce nao tem mensagens\n",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Center(
                        child: Text("Inicie uma conversas na aba Pessoas\n",
                          style: TextStyle(
                              fontSize: 18,)),
                      )                    
                    ],
                  ),
                );
              }

              return ListView.builder(
                  itemCount: mensagens.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot item = mensagens[index];
                    String urlImagem = item["foto"];
                    String tipo = item["tipo"];
                    String mensagem = item["mensagem"];
                    String nome = item["nome"];
                    String idDestinatario = item["idDestinatario"];
                    Usuario usuario = Usuario();
                    usuario.nome = nome;
                    usuario.urlImagem = urlImagem;
                    usuario.idUsuario = idDestinatario;

                    return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteGenerator.TELA_MENSAGEM_ROTA,
                              arguments: usuario);
                        },
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        leading: CircleAvatar(
                          maxRadius: 30, // tamanho de cada avatar
                          backgroundColor: Colors.grey,
                          backgroundImage: urlImagem != null
                              ? NetworkImage(urlImagem)
                              : null,
                        ),
                        title: Text(nome,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        subtitle: tipo == 'texto'
                            ? Text(mensagem,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14))
                            : "Imagem .... ");
                  });
            }
        }
      },
    );
  }
}
