import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Telas/Cadastro.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/RouteGenerate.dart';




class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController(); //Pega oq foi digitado
  TextEditingController _controllerSenha = TextEditingController(); //Pega oq foi digitado
  String _mensagemErro = "";
  
  _validarCampos(){

    //Recupera dados dos campos
    
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( email.isNotEmpty && email.contains("@") ){ // Se o email nao existir e nao tiver @

        if( senha.isNotEmpty  ){//Se a senha nao existir

          setState(() {
            _mensagemErro = "";
          });

          Usuario usuario = Usuario();
          
          usuario.email = email;
          usuario.senha = senha;

          _logarUsuario( usuario );


        }else{
          setState(() {
            _mensagemErro = "Preencha a senha!";
          });
        }

      }else{
        setState(() {
          _mensagemErro = "Preencha o E-mail utilizando @";
        });
      }

  }


  _logarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    
    auth.signInWithEmailAndPassword( //Autenticação para entrar com email e senha
      email: usuario.email, 
      password: usuario.senha
      ).then((FirebaseUser){

        Navigator.pushReplacementNamed(
          context, RouteGenerator.HOME_ROTA
        );

        

      }).catchError((error){

        setState((){ // Caso esteja errado 
          _mensagemErro = "Erro ao autenticar(verifique email e senha";
        });
      });



  }
  Future _verificarLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance; // - Instancia da autenticação 
    //auth.signOut();
    FirebaseUser usuarioLogado = await auth.currentUser(); // - Pega os dados pra ver se o usuario esta logado

    if(usuarioLogado != null){ // Verificaçao
      Navigator.pushReplacementNamed(
        context, RouteGenerator.HOME_ROTA
        );
      
    }
  }
  @override
  void initState() {
    _verificarLogado(); // Antes de executar o Scaffold ele vai verificar se o usuario está logado
    super.initState();
  }
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.deepPurple),
        padding: EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Image.asset("assets/images/logo.png", width: 350,height: 280,fit: BoxFit.fitHeight,),
          ),
          Padding( // Caixa de texto para o email
            padding: EdgeInsets.only(bottom: 8),
            child: TextField(
                controller: _controllerEmail,// - Armazena oq o usuario digita
                
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)))),
          ),
          TextField(// Caixa de texto para a senha
              controller: _controllerSenha, // - Armazena oq o usuario digita
              
              obscureText: true,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  hintText: "Senha",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32)))),
          Padding(// Botao para entrar 
            padding: EdgeInsets.only(bottom: 10, top: 16),
            child: RaisedButton(
              child: Text(
                "Entrar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.deepPurpleAccent,
              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32)
              ),
              onPressed: () {
                _validarCampos();
              },
            ),
          ),
          Center( // - Um GestureDetector para cadastro
            child: GestureDetector(
              child : Text("Sem conta? cadastre-se!!",style: TextStyle(color: Colors.white,fontSize: 17)),
              onTap: (){ // - Ao clica no Gesture o individuo é direcionado para a tela de cadastro
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Cadastro()
                    )
                    );
              },
            )
          ),
          Center( // - Um texto que mostra se o usuario fez algo errado
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
        ]))),
      ),
    );
  }
}
