import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:santa_app/colors.dart';
import 'package:santa_app/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('es'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Santa App',
      theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
              primary: cPrimary,
              secondary: cSecondary,
              background: cBackground)),
      home: HomePage(),
    );
  }
}
