import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/pages/amigos_editar.dart';
import 'package:santa_app/service/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'amigos_agregar.dart';

class AmigosPage extends StatefulWidget {
  AmigosPage({Key? key}) : super(key: key);

  @override
  _AmigosPageState createState() => _AmigosPageState();
}

class _AmigosPageState extends State<AmigosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis amigos'),
        elevation: 0,
      ),
      backgroundColor: cBackground,
      body: FutureBuilder(
        future: getEmailUsuario(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Text('');
          }
          return Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirestoreService().amigos(snapshot.data),
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
                        var amigo = snapshot.data!.docs[index];
                        return Dismissible(
                          key: ObjectKey(snapshot.data!.docs[index]),
                          //direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.brown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Editar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  MdiIcons.pencil,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          secondaryBackground: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerRight,
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Eliminar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(MdiIcons.trashCan, color: Colors.white),
                              ],
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              //EDITAR
                              MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => AmigosEditar(
                                  id: amigo.id,
                                  nombre: snapshot.data!.docs[index]['nombre'],
                                  email: snapshot.data!.docs[index]['email'],
                                  preferencia: snapshot.data!.docs[index]
                                      ['preferencia'],
                                ),
                              );
                              Navigator.push(context, route).then((value) {
                                setState(() {});
                              });
                            } else {
                              FirestoreService().amigosEliminar(amigo.id);
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Amigo eliminado'),
                                  content: Text(
                                      'Se ha eliminado el amigo correctamente.'),
                                ),
                              );
                            }
                          },
                          child: ListTile(
                            leading: Icon(MdiIcons.accountArrowRight),
                            title:
                                Text('${amigo['nombre']} - ${amigo['email']}'),
                            subtitle:
                                Text('Preferencia: ${amigo['preferencia']}'),
                            onTap: () {},
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: cPrimary,
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => AmigosAgregarPage());
          Navigator.push(context, route).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  void _showSnackbar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text(mensaje),
    ));
  }

  Future<String> getEmailUsuario() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_email') ?? '';
  }
}
