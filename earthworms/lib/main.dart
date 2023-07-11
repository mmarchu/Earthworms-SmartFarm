import 'package:earthworms/FirstP/LoginPage.dart';
import 'package:earthworms/FirstP/RegisterPage.dart';
import 'package:earthworms/MainFunc/ChangePassPage.dart';
import 'package:earthworms/MainFunc/MyprofilePage.dart';
import 'package:earthworms/MainFunc/homepage.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
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
        '/profile':(context) =>  MyprofilePage(),
        '/login':(context) => LoginPage(),
        '/regis':(context) => RegisterPage()
      },
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}