import 'package:flutter/material.dart';
import 'package:thaqafah/Log_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "LoginScreen": (context) => LoginPage(),
      },
      initialRoute: "LoginScreen",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
