import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furia_talk/Module/Auth/register_user_pop_up.dart';
import 'package:furia_talk/Module/Home/home_screen.dart';


class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  AuthenticateScreenState createState() => AuthenticateScreenState();
}

class AuthenticateScreenState extends State<AuthenticateScreen> {
  late User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = true;
  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      userCredential;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seja bem-vindo ao Furia Talk')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
          setState(() {
           _errorMessage = "Email/Senha inválidos ou usuário não cadastrado";
          });
        return;
      } else if (e.code == "invalid-email") {
          setState(() {
           _errorMessage = "O email não está no formato correto !!";
          });
        return;
      } else if (e.code == "channel-error") {
          setState(() {
           _errorMessage = "Por favor insira um email e senha validos";
          });
        return;
      }
      setState(() {
        _errorMessage = e.message!;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _register(String userName, String email, String passWord) async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: passWord.trim(),
      );
    await userCredential.user!.updateDisplayName(userName);
    
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
    );
      
    } on FirebaseAuthException catch (e) {
      inspect(e);
    if (e.code == "invalid-email") {
      setState(() {
        _errorMessage = "O email não está no formato correto.";
      });

      
    } else if (e.code == "email-already-in-use") {
      setState(() {
        _errorMessage = "Este email já está sendo utilizado.";
      });
    } else if (e.code == "operation-not-allowed") {
      setState(() {
        _errorMessage = "Cadastro de email/senha desativado. Contate o suporte.";
      });
    } else if (e.code == "weak-password") {
      setState(() {
        _errorMessage = "A senha é muito fraca. Escolha uma senha mais forte.";
      });
    } else {
      setState(() {
        _errorMessage = "Erro desconhecido: ${e.message}";
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    inspect(e);
  
    } catch (e) {
      setState(() {
        _errorMessage = "Erro inesperado: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        elevation: 5.0,
        toolbarHeight: 80,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/furia_talk.png',
                width: 200.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   onPressed: () {
        //     SystemNavigator.pop();
        //   },
        // ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 255, 255, 255)
                
                ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                'assets/Furia_Esports_logo.png',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
               ),
              ),
              const SizedBox(height: 80),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                      labelText: 'Email',
                      border:  OutlineInputBorder(
                        borderSide:  BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  TextField(
                  controller: _passwordController,
                  decoration: 
                     const InputDecoration(
                        labelText: 'Senha',
                        border:  OutlineInputBorder(
                          borderSide:  BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                  obscureText: _showPassword,
                ), Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () { 
                    if (_showPassword == true) {
                      setState(() {
                        _showPassword = false ;
                      });
                      } else {
                        setState(() {
                          _showPassword = true;
                        });
                      }
                    }, 
                    icon: Icon(
                        !_showPassword ? Icons.visibility : Icons.visibility_off
                      )
                  ),
                )],
              ),
              const SizedBox(height: 20),
              if (_errorMessage != "")
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, 
                            ),
                          ),
                          onPressed: _login,
                          child: const Text( 
                            'Entrar',
                            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, 
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _emailController.text = "";
                              _passwordController.text = "";
                            });
                            RegisterUserPopUp.registrationPopup(context, (userName, email, passWord) => _register(userName, email, passWord));
                          },
                          child: const Text(
                            'Cadastrar',
                            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}