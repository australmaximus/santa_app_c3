import 'package:flutter/material.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/service/firestore_service.dart';

class RegalosAgregar extends StatefulWidget {
  String emailAmigo;

  RegalosAgregar({
    Key? key,
    this.emailAmigo = '',
  }) : super(key: key);

  @override
  _RegalosAgregarState createState() => _RegalosAgregarState();
}

class _RegalosAgregarState extends State<RegalosAgregar> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController marcaCtrl = TextEditingController();
  String tipo = 'Electrodomesticos';

  get kSecondaryColor => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar idea de regalo'),
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
                      labelText: 'Nombre del regalo',
                      hintText: 'Ingrese el nombre del regalo'),
                  validator: (nombre) {
                    if (nombre!.isEmpty) {
                      return 'Ingrese nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: marcaCtrl,
                  decoration: InputDecoration(
                      labelText: 'Marca del regalo',
                      hintText: 'Ingrese la marca del regalo'),
                  validator: (nombre) {
                    if (nombre!.isEmpty) {
                      return 'Ingrese marca';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Tipo de regalo: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: tipo,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: TextStyle(color: Colors.red),
                      underline: Container(
                        height: 2,
                        color: kSecondaryColor,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          tipo = newValue!;
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
                    child: Text('Agregar Idea de regalo'),
                    style: ElevatedButton.styleFrom(primary: kSecondaryColor),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        //form ok
                        FirestoreService().ideaAgregar(
                            widget.emailAmigo,
                            nombreCtrl.text.trim(),
                            marcaCtrl.text.trim(),
                            tipo);
                        Navigator.pop(context);
                      }
                    },
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
