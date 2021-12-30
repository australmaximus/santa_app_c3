import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
      ),
      backgroundColor: cBackground,
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Ingrese su email',
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              email = value.toString().trim();
            },
            textAlign: TextAlign.center,
          ),
          //4
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Ingrese su contraseña',
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return "Porfavor ingrese una contraseña";
              }
            },
            onChanged: (value) {
              password = value;
            },
            textAlign: TextAlign.center,
          ),
          Container(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Iniciar sesión'),
                onPressed: () async {
                  UserCredential? userCredential;
                  try {
                    userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    // sp.setString('user_email', emailCtrl.text.trim());
                    sp.setString('user_email', userCredential.user!.email!);
                    // sp.setString('nombre',);
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (contex) => DashboardPage(),
                      ),
                      //si llegamos a esta linea la autenticacion fue correcta
                    );
                  } on FirebaseAuthException catch (e) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(' Ooooops! Inicio de sesión fallido'),
                        content: Text('${e.message}'),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
