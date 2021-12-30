import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/pages/amigos.dart';
import 'package:santa_app/pages/home_page.dart';
import 'package:santa_app/pages/ideas_regalos.dart';
import 'package:santa_app/service/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(5.0),
            height: 200,
            child: Image(
              width: 310,
              image: AssetImage('assets/images/tarjetas.jpg'),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(5.0),
            height: 100,
            child: Column(
              children: [
                Text(
                  'Bienvenido a Santa App!',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                    'Aquí podrás registrar tu lista de amigos y las ideas de ragalos para ellos.',
                    style: TextStyle(fontSize: 20)),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: cOptional,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('App desarrollada por:',
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Nicolás Astudillo - Sebastián Arenas',
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: cBackground,
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: cBackground,
          ),
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/guest.png'),
                        ),
                      ),
                    ),
                    Container(
                      child: FutureBuilder(
                        future: getEmailUsuario(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Text('');
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MdiIcons.emailBox, color: Colors.black),
                              Text(
                                snapshot.data,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: getEmailUsuario(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Text('');
                  }
                  return Container(
                    child: FutureBuilder(
                      future:
                          FirestoreService.obtenerNombreUsuario(snapshot.data),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Text('');
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.account, color: Colors.black),
                            Text(
                              snapshot.data,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  MdiIcons.homeOutline,
                  color: cPrimary,
                ),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Icon(
                  MdiIcons.contacts,
                  color: cOptional,
                ),
                title: Text('Amigos'),
                onTap: () {
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => AmigosPage());
                  Navigator.push(context, route).then((value) {
                    setState(() {});
                  });
                },
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Icon(
                  MdiIcons.gift,
                  color: cPrimary,
                ),
                title: Text('Ideas de Regalos'),
                onTap: () {
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => IdeasRegalosPage());
                  Navigator.push(context, route).then((value) {
                    setState(() {});
                  });
                },
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Icon(
                  MdiIcons.logoutVariant,
                  color: cPrimary,
                ),
                title: Text('Cerrar sesión'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => HomePage());
                  Navigator.push(context, route).then((value) {
                    setState(() {});
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getEmailUsuario() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_email') ?? '';
  }
}
