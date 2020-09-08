import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  TextEditingController _controllerNome = TextEditingController();
  File _imagemAvatar;
  String _idUser;
  bool _subindoImagem = false;
  String _urlRecuperada;
  String nomeUser;
  Future _photo(String photo) async {
    File imagem;
    switch (photo) {
      case "camera":
        imagem = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagem = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagemAvatar = imagem;

      if (_imagemAvatar != null) {
        _subindoImagem = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo =
        pastaRaiz.child("perfil").child(_idUser + ".jpg");
    StorageUploadTask task = arquivo.putFile(_imagemAvatar);
    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _urlImagem(snapshot);
    });
  }

  Future _urlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarImagem(url);
    setState(() {
      _urlRecuperada = url;
    });
  }

  _atualizarNome() {
    Firestore db = Firestore.instance;
    String nome = _controllerNome.text;
    Map<String, dynamic> dadosAtualizados = {"nome": nome};
    db.collection("usuarios").document(_idUser).updateData(dadosAtualizados);
  }

  _atualizarImagem(String url) {
    Firestore db = Firestore.instance;
    Map<String, dynamic> dadosAtualizados = {"urlImagem": url};
    db.collection("usuarios").document(_idUser).updateData(dadosAtualizados);
  }

  _recuperarDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuario = await auth.currentUser();
    _idUser = usuario.uid;
    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(_idUser).get();
    Map<String, dynamic> dados = snapshot.data;
    _controllerNome.text = dados["nome"];
    if (dados["urlImagem"] != null) {
      setState(() {
        _urlRecuperada = dados["urlImagem"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configuração", style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.all(16),
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              _subindoImagem // SE FOR TRUE ELE CARREGA
                  ? CircularProgressIndicator()
                  : Container(),
              Padding(
                padding: EdgeInsets.all(16),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.black,
                  radius: 100,
                  //maxRadius: 200,
                  //minRadius: 100,
                  backgroundImage: _urlRecuperada != null
                      ? NetworkImage(_urlRecuperada.toString())
                      : null,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          child: Text("Camera"),
                          onPressed: () {
                            _photo("camera");
                          }),
                      FlatButton(
                          child: Text("Galeria"),
                          onPressed: () {
                            _photo("galeria");
                          }),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _controllerNome,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 10),
                child: RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.deepPurpleAccent,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _atualizarNome();
                    }),
              ),
            ],
          ))),
        ));
  }
}
