import 'package:earthworms/Profile/LoginPage.dart';
// import 'package:earthworms/FirstP/RegisterPage.dart';
// import 'package:earthworms/MainFunc/ChangePassPage.dart';
// import 'package:earthworms/MainFunc/MyprofilePage.dart';
// import 'package:earthworms/MainFunc/homepage.dart';
import 'package:flutter/material.dart';
// import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(MyApp());
}

class MainColors {
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
      // routes: {
      //   '/home': (context) => homepage(),
      //   '/password': (context) => ChangePassPage(),
      //   '/profile': (context) => MyprofilePage(),
      //   '/login': (context) => LoginPage(),
      //   '/regis': (context) => RegisterPage()
      // },
      debugShowCheckedModeBanner: false,

      home: LoginPage(),
      // home: ResponsiveWrapper(
      //   child: LoginPage(),
      //   maxWidth:
      //       1200, // กำหนดความกว้างของหน้าจอสูงสุดที่คุณต้องการให้แอปของคุณปรับขนาด
      //   minWidth: 400, // กำหนดความกว้างของหน้าจอขั้นต่ำ
      //   defaultScale: true,
      //   breakpoints: [
      //     ResponsiveBreakpoint.resize(450, name: MOBILE),
      //     ResponsiveBreakpoint.resize(800, name: TABLET),
      //     ResponsiveBreakpoint.resize(1200, name: DESKTOP),
      //   ],
      // ),
    );
  }
}
