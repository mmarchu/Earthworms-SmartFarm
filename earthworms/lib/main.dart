import 'package:earthworms/FirstP/LoginPage.dart';
import 'package:earthworms/FirstP/RegisterPage.dart';
import 'package:earthworms/MainFunc/ChangePassPage.dart';
import 'package:earthworms/MainFunc/MyprofilePage.dart';
import 'package:earthworms/MainFunc/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

 class MainColors{
    final GreenTextFieldANDmainButton = Color.fromRGBO(42, 62, 54, 1);
    final Yellow = Color.fromRGBO(239, 165, 38, 1);
    final GreenText = Color(0xff0e4f55);
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => homepage(),
        '/password': (context) => ChangePassPage(),
        '/profile': (context) => MyprofilePage(),
        '/login': (context) => LoginPage(),
        '/regis': (context) => RegisterPage()
      },
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
