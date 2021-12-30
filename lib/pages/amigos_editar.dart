import 'package:flutter/material.dart';
import 'package:santa_app/service/firestore_service.dart';

import '../colors.dart';

class AmigosEditar extends StatefulWidget {
  String id, nombre, email, preferencia;

  AmigosEditar(
      {Key? key,
      this.id = '',
      this.nombre = '',
      this.email = '',
      this.preferencia = ''})
      : super(key: key);

  @override
  _AmigosEditarState createState() => _AmigosEditarState();
}

class _AmigosEditarState extends State<AmigosEditar> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  String preferencia = 'Electrodomesticos';
  final emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  @override
  void initState() {
    super.initState();
    nombreCtrl.text = widget.nombre;
    emailCtrl.text = widget.email;
    preferencia = widget.preferencia;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar'),
      ),
      backgroundColor: cBackground,
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextFormField(
                  controller: nombreCtrl,
                  decoration: InputDecoration(
                      labelText: 'Nombre del amigo',
                      hintText: 'Ingrese el nombre del amigo'),
                  validator: (nombre) {
                    if (nombre!.isEmpty) {
                      return 'Ingrese nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Ingrese el email del amigo'),
                  validator: (email) {
                    if (email!.isEmpty) {
                      return 'Indique Email';
                    }
                    if (!RegExp(emailRegex).hasMatch(email)) {
                      return 'Formato de email no válido';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Preferencia: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: preferencia,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: cPrimary),
                      underline: Container(
                        height: 2,
                        color: cPrimary,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          preferencia = newValue!;
                        });
                      },
                      items: <String>[
                        'Electrodomesticos',
                        'Electronica',
                        'Dormitorio',
                        'Cocina'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    child: Text('Actualizar Amigo'),
                    style: ElevatedButton.styleFrom(primary: cPrimary),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        //form ok
                        FirestoreService().amigosEditar(
                            widget.id,
                            nombreCtrl.text.trim(),
                            emailCtrl.text.trim(),
                            preferencia);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
