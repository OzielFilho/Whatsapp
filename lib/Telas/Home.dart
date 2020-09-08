import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Tabs/Contatos.dart';
import 'package:whatsapp/Tabs/Conversas.dart';
import 'package:whatsapp/Telas/Login.dart';
import 'package:whatsapp/RouteGenerate.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String _emailUsuario = "";
  TabController _tabController;
  
  List<String> itensMenu = ["Configuraçao", "Deslogar"];

  Future _recuperarDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    
    setState(() {
      _emailUsuario = usuarioLogado.email;
    });
  }
  Future _verificarLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance; // - Instancia da autenticação 
    
    FirebaseUser usuarioLogado = await auth.currentUser(); // - Pega os dados pra ver se o usuario esta logado

    if(usuarioLogado == null){ // Verificaçao
      Navigator.pushReplacementNamed(
        context, RouteGenerator.LOGIN_ROTA
        );
      
    }
  }

  @override
  void initState() {
    _verificarLogado(); 
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _recuperarDados();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _escolhaMenuItem(String itemEscolhido) {
    //print("item: " + itemEscolhido);
    switch (itemEscolhido) {
      case "Configuraçao":
        Navigator.pushNamed(context, RouteGenerator.CONFIGURACA_ROTA);
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(
      context, RouteGenerator.LOGIN_ROTA);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Fast Messenger", style: TextStyle(color: Colors.white)),
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3.5,
              tabs: <Widget>[
                Tab(
                  //text: "Conversas",
                  child: Text(
                    "Conversas",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "Pessoas",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
          actions: [
            PopupMenuButton<String>(
                // um popup que cada item é String
                color: Colors.white,
                onSelected: _escolhaMenuItem, //captura oq vai ser selecinado
                itemBuilder: (context) {
                  //constroi os itens que vao ser exibidos
                  return itensMenu.map((String item) {
                    //lista de itens que vou percorrer usando o map
                    return PopupMenuItem<String>(
                      //Retorna meu popup exibindo oq foi percorrido
                      value: item, //cada item que estava dentro do map
                      child: Text(item),
                    );
                  }).toList();
                }),
          ],
        ),
        body: TabBarView(
            controller: _tabController,
            children: <Widget>[Conversas(), Contatos()]));
  }
}
