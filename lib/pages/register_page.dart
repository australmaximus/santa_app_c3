import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/service/firestore_service.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  String nombre = '';
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar usuario'),
      ),
      backgroundColor: cBackground,
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nombre',
              hintText: 'Ingrese su nombre',
            ),
            keyboardType: TextInputType.name,
            onChanged: (value) {
              nombre = value.toString().trim();
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Ingrese un email',
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              email = value.toString().trim();
            },
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
                return "Por favor ingrese una contraseña";
              }
            },
            onChanged: (value) {
              password = value;
            },
          ),
          Container(
            child: Container(
              child: ElevatedButton(
                child: Text('Registrar'),
                onPressed: () async {
                  try {
                    await FirestoreService.crearUsuario(
                        email, password, nombre);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content:
                          Text('Registro exitoso. Puede iniciar sesión ahora'),
                    ));
                    Navigator.of(context).pop();
                  } on FirebaseAuthException catch (e) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Registro fallido'),
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

  void _showSnackbar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text(mensaje),
    ));
  }
}
