import 'dart:convert';
import 'dart:io';
import 'package:earthworms/HomeandData/homepage.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:earthworms/MainFunction/SessionToken.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  runApp(MyApp());
}

String DBname = '';
String DBlastname = '';
String DBemail = '';
List<dynamic> DBSensorsDynamic = [];

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
  String? email = await loadData('email');
  var url;
  if (Platform.isAndroid) {
    url = 'http://10.0.2.2:4000/api/auth/getoneuser';
    //url = 'http://192.168.1.40:4000/api/auth/getoneuser';
  } else if (Platform.isIOS) {
    url = 'http://127.0.0.1:4000/api/auth/getoneuser';
  }

  if (token == null) {
    // ถ้าไม่มี token, ส่งค่า 400 กลับ
    print('no token jaaa');
    return 401;
  }

  if (email == null) {
    return 401;
  }

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charest=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email}));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    DBemail = data['email'];
    DBname = data['name'];
    DBlastname = data['lastname'];
    DBSensorsDynamic = data['sensors'];

    return 200;
  } else {
    return response.statusCode;
  }
}
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
                List<String> sensorIdList = [];
                List<String> macAddressList = [];
                List<String> sensorNameList = [];
                List<String> GpioList = [];
                List<bool> modeList = [];
                List<bool> powerList = [];

                // ignore: unnecessary_null_comparison, unnecessary_type_check
                if (DBSensorsDynamic != null && DBSensorsDynamic is List) {
                  sensorIdList =
                      DBSensorsDynamic.map((item) => item['id'].toString())
                          .toList();
                  macAddressList = DBSensorsDynamic.map(
                      (item) => item['macAddress'].toString()).toList();
                  sensorNameList =
                      DBSensorsDynamic.map((item) => item['name'].toString())
                          .toList();
                  GpioList =
                      DBSensorsDynamic.map((item) => item['gpio'].toString())
                          .toList();
                  modeList = DBSensorsDynamic.map(
                      (item) => item['mode'].toString() == '1').toList();
                  powerList = DBSensorsDynamic.map(
                      (item) => item['power'].toString() == '1').toList();
                }
                ConMqtt(DBemail);
                return HomePage(
                  name: DBname,
                  lastname: DBlastname,
                  email: DBemail,
                  sensorIdList: sensorIdList,
                  macAddressList: macAddressList,
                  sensorNameList: sensorNameList,
                  GpioList: GpioList,
                  modeList: modeList,
                  powerList: powerList,
                );
                // return Newhomepage(
                //     email: DBemail, name: DBname, lastname: DBlastname);
              }
            }
          },
        ));
  }
}
