import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/pages/login_page.dart';
import 'package:santa_app/pages/register_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio - Santa App'),
        leading: Icon(MdiIcons.pineTree),
        backgroundColor: cOptional,
      ),
      body: Container(
        decoration: new BoxDecoration(color: cBackground),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'BIENVENIDO',
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(5.0),
              height: 200,
              child: Image(
                width: 310,
                image: AssetImage('assets/images/arbol.png'),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => RegisterPage());
                  Navigator.push(context, route).then((value) {
                    setState(() {});
                  });
                },
                child: Text('Registrarse'),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => LoginPage());
                  Navigator.push(context, route).then((value) {
                    setState(() {});
                  });
                },
                child: Text('Iniciar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
