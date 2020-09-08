import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/RouteGenerate.dart';
import 'package:whatsapp/Tabs/Conversas.dart';
import 'package:whatsapp/model/ListConversas.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  String _idUsuariologado;
  String _emailUsuariologado;
  
  Future<List<Usuario>> _recuperarContatos() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot =
        await db.collection("usuarios").getDocuments();
    List<Usuario> listaUsuarios = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      
      if(dados["email"] == _emailUsuariologado) continue;
      Usuario usuario = Usuario();
      usuario.email = dados["email"];
      usuario.nome = dados["nome"];
      usuario.urlImagem = dados["urlImagem"];
      usuario.idUsuario = item.documentID;
      listaUsuarios.add(usuario);
    }
    return listaUsuarios;
  }
  _recuperarDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuario = await auth.currentUser();
    _idUsuariologado = usuario.uid;
    setState(() {
     _emailUsuariologado = usuario.email;
    });
    
           
  }
  @override
  void initState() {
    super.initState();
    _recuperarDados();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(children: <Widget>[
                
                CircularProgressIndicator()
              ]),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  List<Usuario> listaItens = snapshot.data;
                  Usuario usuario = listaItens[index];
                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        RouteGenerator.TELA_MENSAGEM_ROTA,
                        arguments: usuario
                        );
                    },
                    contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    leading: CircleAvatar(
                        maxRadius: 27, // tamanho de cada avatar
                        backgroundColor: Colors.grey,
                        backgroundImage: usuario.urlImagem != null
                            ? NetworkImage(usuario.urlImagem)
                            : null),
                    title: Text(usuario.nome,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  );
                });
            break;
        }
      },
    );
  }
}
