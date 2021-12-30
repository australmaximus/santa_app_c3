import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/pages/regalos_agregar.dart';
import 'package:santa_app/service/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegalosPage extends StatefulWidget {
  String emailAmigo, nombre;

  RegalosPage({
    Key? key,
    this.emailAmigo = '',
    this.nombre = '',
  }) : super(key: key);

  @override
  _RegalosPageState createState() => _RegalosPageState();
}

class _RegalosPageState extends State<RegalosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regalos para: ' + widget.nombre),
      ),
      backgroundColor: cBackground,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirestoreService().ideas(widget.emailAmigo),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var idea = snapshot.data!.docs[index];
                    return ListTile(
                      leading: Icon(MdiIcons.gift, color: cPrimary),
                      title: Text('${idea['nombreRegalo']} - ${idea['marca']}'),
                      subtitle: Text('Tipo: ${idea['tipo']}'),
                      trailing: ElevatedButton(
                          onPressed: () async {
                            FirestoreService().ideasEliminar(idea.id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content:
                                  Text('Se ha eliminado la idea de regalo'),
                            ));
                          },
                          child: Text('Eliminar')),
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: cOptional,
        child: Icon(Icons.add),
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => RegalosAgregar(
                    emailAmigo: widget.emailAmigo,
                  ));
          Navigator.push(context, route).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  Future<String> getEmailUsuario() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_email') ?? '';
  }

  void _showSnackbar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text(mensaje),
    ));
  }
}
