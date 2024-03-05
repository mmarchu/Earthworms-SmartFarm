import 'dart:convert';
import 'package:earthworms/HomeandData/homepage.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:earthworms/MainFunction/SessionToken.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';

Future<void> main() async {
  runApp(MyApp());
}

String DBname = '';
String DBlastname = '';
String DBemail = '';

class MainColors {
  final GreenTextFieldANDmainButton = Color.fromRGBO(42, 62, 54, 1);
  final Yellow = Color.fromRGBO(239, 165, 38, 1);
  final GreenText = Color(0xff0e4f55);
}

//Token--------------------------------------------
Future<String?> loadData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<int> CheckToken() async {
  String? token = await loadData('Token');

  if (token == null) {
    // ถ้าไม่มี token, ส่งค่า 400 กลับ
    print('no token jaaa');
    return 401;
  }

  final response = await http.get(
    Uri.parse('http://localhost:4000/api/auth/getoneuser'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    DBemail = data['email'];
    DBname = data['name'];
    DBlastname = data['lastname'];
    return 200;
  } else {
    return response.statusCode;
  }
}
//-------------------------------------------------

//mqtt---------------------------------------------

//-------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        //home: LoginPage(),

        home: FutureBuilder(
          future: CheckToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('Waiting');
              return SessionToken();
            } else {
              if (snapshot.hasError || snapshot.data == 401) {
                print('back to login');
                return LoginPage();
              } else {
                print('go to homepage');
                ConMqtt();
                return homepage(
                    email: DBemail, name: DBname, lastname: DBlastname);
              }
            }
          },
        ));
  }
}
