import 'dart:convert';
import 'dart:io';
import 'package:earthworms/HomeandData/Components/url.dart';
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

String id = '';
String DBname = '';
String DBlastname = '';
String DBemail = '';
List<dynamic> DBSensorsDynamic = [];

//Token--------------------------------------------
Future<String?> loadData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<int> CheckToken() async {
  String? token = await loadData('Token');
  String? idString = await loadData('user_id');
  var url;
  if (Platform.isAndroid) {
    url = ApiUrl.ANDgetoneuser;
  } else if (Platform.isIOS) {
    url = ApiUrl.IOSgetoneuser;
  }

  if (token == null) {
    // ถ้าไม่มี token, ส่งค่า 400 กลับ
    print('no token jaaa');
    return 401;
  }

  if (idString == null) {
    // ถ้าไม่มี user_id, ส่งค่า 400 กลับ
    print('no idString jaaa');
    return 401;
  }

  // Convert idString to an integer
  int? id = int.tryParse(idString);
  if (id == null) {
    print('int id null jaaa');
    return 401;
  }

  try {
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': id}));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      id = data['id'];
      DBemail = data['email'];
      DBname = data['name'];
      DBlastname = data['lastname'];
      DBSensorsDynamic = data['sensors'];

      return 200;
    } else {
      return response.statusCode;
    }
  } catch (e) {
    print('Failed to connect to server: $e');
    print(401);
    return 401;
  }
}
//-------------------------------------------------

// Future<void> UnSubMQTT() async {
//   String? email = await loadData('email');
//   String subTopicEmailNotofy = '$email/notify';
//   String subTopicEmailSensor = '$email/flora';
//   String subTopicEnemiesNotify = 'Enemies/notify';

//   client.unsubscribe(subTopicEnemiesNotify);
//   client.unsubscribe(subTopicEmailNotofy);
//   client.unsubscribe(subTopicEmailSensor);
//   print("UnSubscribe topic: $subTopicEmailNotofy");
//   print("UnSubscribe topic: $subTopicEmailSensor");
//   print("UnSubscribe topic: $subTopicEnemiesNotify");
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: CheckToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('Waiting');

              return SessionToken();
            } else {
              if (snapshot.hasError || snapshot.data == 401) {
                print('back to login');
                // UnSubMQTT();
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
                  id: id,
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
              }
            }
          },
        )
        //home: testtest(),
        );
  }
}
