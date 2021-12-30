import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/pages/amigos_editar.dart';
import 'package:santa_app/pages/regalos.dart';
import 'package:santa_app/service/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'amigos_agregar.dart';

class IdeasRegalosPage extends StatefulWidget {
  IdeasRegalosPage({Key? key}) : super(key: key);

  @override
  _IdeasRegalosPageState createState() => _IdeasRegalosPageState();
}

class _IdeasRegalosPageState extends State<IdeasRegalosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ideas de regalos para amigos'),
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
                        return ListTile(
                          leading: Icon(
                            MdiIcons.accountSearch,
                            color: cOptional,
                          ),
                          title: Text('${amigo['nombre']} - ${amigo['email']}'),
                          subtitle:
                              Text('Preferencia: ${amigo['preferencia']}'),
                          trailing: Text('Presione'),
                          onTap: () {
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => RegalosPage(
                                      emailAmigo: snapshot.data!.docs[index]
                                          ['email'],
                                      nombre: snapshot.data!.docs[index]
                                          ['nombre'],
                                    ));
                            Navigator.push(context, route).then((value) {
                              setState(() {});
                            });
                          },
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
