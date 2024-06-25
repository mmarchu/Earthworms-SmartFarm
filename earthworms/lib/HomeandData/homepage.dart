import 'dart:async';
import 'dart:convert';
import 'package:earthworms/HomeandData/AddSensorPage.dart';
import 'package:earthworms/HomeandData/Components/HomeWidget.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:earthworms/TestFunc/Sensor2Responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String lastname;
  final String email;
  final List<String> sensorIdList;
  final List<String> macAddressList;
  final List<String> sensorNameList;
  HomePage(
      {required this.name,
      required this.lastname,
      required this.email,
      required this.sensorIdList,
      required this.macAddressList,
      required this.sensorNameList});

  @override
  State<HomePage> createState() => _HomePageState();
}

//Delete Token in SharePref
Future<void> removeData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

//Func. Logout
void _logout() async {
  await removeData('Token');
  await removeData('email');
  print("Log out");
}

class _HomePageState extends State<HomePage> {
  //final StreamController<Map<String, List<String>>> _dataController = StreamController<Map<String, List<String>>>();
  final BehaviorSubject<Map<String, List<String>>> _dataController =
      BehaviorSubject<Map<String, List<String>>>();
  List<bool> mode = [true, false, false, true, true, false, true];
  List<bool> power = [false, true, true, false, false, false, false];
  TextEditingController lastnameController = TextEditingController();
  final List<String> humidity = [];
  final List<String> temp = [];

  //OnTapBottmBar
  void _OnTapBottomBar(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TimeSeriesPage()));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddSensorPage(
                      name: widget.name,
                      lastname: widget.lastname,
                      email: widget.email,
                    )));
        break;
      case 2:
        showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Are you sure?'),
                  content: Text(
                      'Are you sure you want to logout of the application'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.blue),
                        )),
                    CupertinoDialogAction(
                        onPressed: () {
                          _logout();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (Route<dynamic> Route) => false);
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateMQTT();
  }

//Get data from sensor by MQTT
  Future<void> _updateMQTT() async {
    Timer.periodic(Duration(seconds: 5), (timer) {
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print(pt);
        //_MQTTtoJsonList(pt);
      });
    });
  }

  void _MQTTtoJsonList(
    String message,
  ) {
    final Map<String, dynamic> parsedData = jsonDecode(message);

    List<String> humidity = parsedData['Humidity'].split(',');
    List<String> temp = parsedData['Temp'].split(',');

    _dataController.add({'Humidity': humidity, 'Temp': temp});
    print(humidity);
    print(temp);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    return LayoutBuilder(builder: (context, Constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          screenWidth < screenHeight ? screenWidth : screenHeight;
      final textScaleFactor = smallestDimension / 400;
      return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: Color.fromRGBO(250, 246, 229, 1),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                    size: 29 * textScaleFactor,
                  ),
                  label: 'Add Sensor',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout_rounded),
                  label: 'Logout',
                ),
              ],
              currentIndex: 0,
              selectedItemColor: Color.fromRGBO(232, 225, 198, 1),
              unselectedItemColor: Colors.white,
              backgroundColor: Color(0xff0e4f55),
              onTap: _OnTapBottomBar,
            ),
            body: Stack(
              children: [
                // Name Lastname Logo
                Container(
                  height: screenHeight,
                  color: Color(0xff0e4f55),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 65 * textScaleFactor,
                            left: 40 * textScaleFactor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Name Lastname
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.name,
                                    style: TextStyle(
                                        fontSize: 30 * textScaleFactor,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 2 * textScaleFactor),
                                    child: Text(
                                      widget.lastname,
                                      style: TextStyle(
                                          fontSize: 30 * textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 213, 205, 205)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //Logo picture
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 30 * textScaleFactor),
                              child: Container(
                                width: 80 * textScaleFactor,
                                height: 80 * textScaleFactor,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "images/EarthwormLogo.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Sensor Widget
                Positioned(
                  top: screenHeight * 0.2,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(27),
                        topRight: Radius.circular(27)),
                    child: Container(
                        color: Color.fromRGBO(250, 246, 229, 1),
                        child: Column(
                          children: [
                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: 10 * textScaleFactor),
                            //   child: Text(
                            //     "THE EARTHWORM'S SMARTFARM",
                            //     style: TextStyle(
                            //         fontSize: 18 * textScaleFactor,
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.macAddressList.length,
                                itemBuilder: (context, index) {
                                  return HomeWidget(
                                    NameSensor: widget.sensorNameList[index],
                                    macAddress: widget.macAddressList[index],
                                    email: widget.email,
                                    mode: mode[index],
                                    power: power[index],
                                    humidity: _dataController.hasValue
                                        ? _dataController.value['Humidity'] ??
                                            []
                                        : [],
                                    temp: _dataController.hasValue
                                        ? _dataController.value['Temp'] ?? []
                                        : [],
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
