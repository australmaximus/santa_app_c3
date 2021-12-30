import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/service/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmigosAgregarPage extends StatefulWidget {
  AmigosAgregarPage({Key? key}) : super(key: key);

  @override
  _AmigosAgregarPageState createState() => _AmigosAgregarPageState();
}

class _AmigosAgregarPageState extends State<AmigosAgregarPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  final emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  DateTime cumple = DateTime.now();
  String preferencia = 'Electrodomesticos';
  var fFecha = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Amigos'),
        elevation: 0,
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
                      'Fecha de Nacimiento (cumple): ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      fFecha.format(cumple),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    TextButton(
                      child: Icon(MdiIcons.calendar),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          locale: Locale('es', 'ES'),
                        ).then((fecha) {
                          setState(() {
                            cumple = fecha == null ? cumple : fecha;
                          });
                        });
                      },
                    ),
                  ],
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
                FutureBuilder(
                  future: getEmailUsuario(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Text('');
                    }
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        child: Text('Agregar Amigo'),
                        style: ElevatedButton.styleFrom(primary: cPrimary),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            //form ok
                            FirestoreService().amigosAgregar(
                                snapshot.data,
                                nombreCtrl.text.trim(),
                                emailCtrl.text.trim(),
                                preferencia,
                                cumple);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void showSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 2),
    ));
  }

  Future<String> getEmailUsuario() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_email') ?? '';
  }
}
