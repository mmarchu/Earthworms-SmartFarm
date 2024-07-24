import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:earthworms/HomeandData/AddSensorPage.dart';
import 'package:earthworms/HomeandData/SensorDetailPage.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:earthworms/TestFunc/AutoScale.dart';
import 'package:earthworms/TestFunc/Sensor2Responsive.dart';
import 'package:earthworms/TestFunc/datepick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String name;
  final String lastname;
  final String email;
  final List<String> sensorIdList;
  final List<String> macAddressList;
  final List<String> sensorNameList;
  final List<String> GpioList;
  final List<bool> modeList;
  final List<bool> powerList;
  HomePage(
      {required this.name,
      required this.lastname,
      required this.email,
      required this.sensorIdList,
      required this.macAddressList,
      required this.sensorNameList,
      required this.GpioList,
      required this.modeList,
      required this.powerList});

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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final BehaviorSubject<Map<String, List<String>>> _dataController =
      BehaviorSubject<Map<String, List<String>>>();
  TextEditingController lastnameController = TextEditingController();
  final List<String> humidity = [];
  final List<String> temp = [];

  @override
  void initState() {
    super.initState();
    _updateMQTT();
    _TokenChenkTimeout();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("Paused");
    }
    if (state == AppLifecycleState.resumed) {
      CheckToken();
    }
  }

  @override
  void dispose() {
    // Remove observer when the state is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _TokenChenkTimeout() {
    Timer.periodic(Duration(minutes: 5), (timer) {
      CheckToken();
    });
  }

  Future<void> CheckToken() async {
    String? token = await loadData('Token');
    String? email = await loadData('email');
    var url;

    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:4000/api/auth/getoneuser';
      //url = 'http://192.168.1.40:4000/api/auth/getoneuser';
    } else if (Platform.isIOS) {
      url = 'http://127.0.0.1:4000/api/auth/getoneuser';
      //IP HomeWifi
      //url = 'http://192.168.1.40:4000/api/auth/getoneuser';
    }

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charest=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'email': email}));

    if (response.statusCode == 200) {
      print("ยังอยู่จ้าาOnHomPage");
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Session Timeout'),
            actions: <Widget>[
              Column(
                children: [
                  Text("Session expired. You will be redirected to Login page"),
                  TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Color(0xff0e4f55)),
                    ),
                    onPressed: () {
                      _logout();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> Route) => false);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

//OnTapBottmBar
  void _OnTapBottomBar(int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CalendarRangePicker()));
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

//Get data from sensor by MQTT
  Future<void> _updateMQTT() async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        //print(pt);
        _MQTTtoJsonList(pt);
      });
    });
  }

//Map Sensor data to List
  void _MQTTtoJsonList(String message) {
    try {
      final List<dynamic> parsedData = jsonDecode(message);
      List<String> macAddresses = [];
      List<String> temperatures = [];
      List<String> moisture = [];
      List<String> lights = [];
      List<String> conductivities = [];
      List<String> batteries = [];

      for (var item in parsedData) {
        macAddresses.add(item['macAddress'].toString());
        temperatures.add(item['temperature'].toString());
        moisture.add(item['moisture'].toString());
        lights.add(item['light'].toString());
        conductivities.add(item['conductivity'].toString());
        batteries.add(item['battery'].toString());
      }

      _dataController.add({
        'MacAddress': macAddresses,
        'Temperature': temperatures,
        'Moisture': moisture,
        'Light': lights,
        'Conductivity': conductivities,
        'Battery': batteries,
      });

      // Uncomment the following lines for debugging
      // print(macAddresses);
      // print(temperatures);
      // print(moisture);
      // print(lights);
      // print(conductivities);
      // print(batteries);
    } catch (e) {
      print('Error processing JSON data: $e');
    }
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
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.macAddressList.length,
                                itemBuilder: (context, index) {
                                  // return HomeWidget(
                                  //   NameSensor: widget.sensorNameList[index],
                                  //   macAddress: widget.macAddressList[index],
                                  //   email: widget.email,
                                  //   mode: mode[index],
                                  //   power: power[index],
                                  //   humidity: _dataController.hasValue
                                  //       ? _dataController.value['Humidity'] ??
                                  //           []
                                  //       : [],
                                  //   temp: _dataController.hasValue
                                  //       ? _dataController.value['Temp'] ?? []
                                  //       : [],
                                  // );
                                  return Column(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            print(widget.sensorNameList[index]);
                                            print(widget.macAddressList[index]);
                                            print(widget.modeList[index]);
                                            print(widget.modeList[index]);
                                            print("index: $index");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SensorDetailPage(
                                                          nameSensor: widget
                                                                  .sensorNameList[
                                                              index],
                                                          macAddress: widget
                                                                  .macAddressList[
                                                              index],
                                                          email: widget.email,
                                                          sensorId: widget
                                                                  .sensorIdList[
                                                              index],
                                                          index: index,
                                                          mode: widget
                                                              .modeList[index],
                                                          power: widget
                                                              .powerList[index],
                                                          GpioList: widget
                                                              .GpioList[index],
                                                        )));
                                          },
                                          child: SizedBox(
                                            width: 360 * textScaleFactor,
                                            height: 250 * textScaleFactor,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      232, 225, 198, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          27)),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: AutoSizeText(
                                                      widget.sensorNameList[
                                                          index],
                                                      style: TextStyle(
                                                        fontSize: 23 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      //Humidity
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 20 *
                                                                textScaleFactor,
                                                          ),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: 150 *
                                                                      textScaleFactor,
                                                                  height: 115 *
                                                                      textScaleFactor,
                                                                  child:
                                                                      DecoratedBox(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color.fromRGBO(
                                                                          250,
                                                                          246,
                                                                          229,
                                                                          1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      //boxShadow: [BoxShadow(blurRadius: 1)]
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        top: 15 *
                                                                            textScaleFactor,
                                                                        left: 15 *
                                                                            textScaleFactor,
                                                                        right: 15 *
                                                                            textScaleFactor,
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 8 * textScaleFactor),
                                                                                child: Text(
                                                                                  "Humidity",
                                                                                  style: TextStyle(fontSize: 19 * textScaleFactor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                              Image.asset(
                                                                                "images/humidity.png",
                                                                                height: 28 * textScaleFactor,
                                                                                width: 28 * textScaleFactor,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(bottom: 20 * textScaleFactor, top: 6 * textScaleFactor),
                                                                                child: StreamBuilder<Map<String, List<String>>>(
                                                                                  stream: _dataController.stream,
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      List<String> humidity = snapshot.data!['Moisture'] ?? [];
                                                                                      if (humidity.isNotEmpty && humidity[index].isNotEmpty) {
                                                                                        return Text(
                                                                                          '${humidity[index]}%',
                                                                                          style: TextStyle(
                                                                                            fontSize: 25 * textScaleFactor,
                                                                                            fontWeight: FontWeight.normal,
                                                                                          ),
                                                                                        );
                                                                                      } else {
                                                                                        return Text(
                                                                                          'N/A%',
                                                                                          style: TextStyle(
                                                                                            fontSize: 25 * textScaleFactor,
                                                                                            fontWeight: FontWeight.normal,
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      return Text(
                                                                                        'N/A%',
                                                                                        style: TextStyle(
                                                                                          fontSize: 25 * textScaleFactor,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20 *
                                                                      textScaleFactor,
                                                                ),
                                                                //Temperature
                                                                SizedBox(
                                                                  width: 150 *
                                                                      textScaleFactor,
                                                                  height: 115 *
                                                                      textScaleFactor,
                                                                  child:
                                                                      DecoratedBox(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color.fromRGBO(
                                                                          250,
                                                                          246,
                                                                          229,
                                                                          1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      //boxShadow: [BoxShadow(blurRadius: 1)]
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        top: 15 *
                                                                            textScaleFactor,
                                                                        left: 15 *
                                                                            textScaleFactor,
                                                                        right: 15 *
                                                                            textScaleFactor,
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 8 * textScaleFactor),
                                                                                child: Text(
                                                                                  "Temperature",
                                                                                  style: TextStyle(fontSize: 15 * textScaleFactor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                              Image.asset(
                                                                                "images/temperature-sensor.png",
                                                                                height: 20 * textScaleFactor,
                                                                                width: 20 * textScaleFactor,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(bottom: 20 * textScaleFactor, top: 13 * textScaleFactor),
                                                                                child: StreamBuilder<Map<String, List<String>>>(
                                                                                  stream: _dataController.stream,
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      List<String> temp = snapshot.data!['Temperature'] ?? [];
                                                                                      if (temp.isNotEmpty && temp[index].isNotEmpty) {
                                                                                        return Text(
                                                                                          '${temp[index]}%',
                                                                                          style: TextStyle(
                                                                                            fontSize: 25 * textScaleFactor,
                                                                                            fontWeight: FontWeight.normal,
                                                                                          ),
                                                                                        );
                                                                                      } else {
                                                                                        return Text(
                                                                                          'N/A%',
                                                                                          style: TextStyle(
                                                                                            fontSize: 25 * textScaleFactor,
                                                                                            fontWeight: FontWeight.normal,
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      return Text(
                                                                                        'N/A%',
                                                                                        style: TextStyle(
                                                                                          fontSize: 25 * textScaleFactor,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          17 * textScaleFactor),
                                                  SizedBox(
                                                    width: 350,
                                                    height: 50,
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            250, 246, 229, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: 5 *
                                                                    textScaleFactor,
                                                                bottom: 5 *
                                                                    textScaleFactor,
                                                                right: 8 *
                                                                    textScaleFactor),
                                                            child: Image.asset(
                                                                "images/water-pump.png"),
                                                          ),
                                                          Text(
                                                            "Water Pump Mode: ",
                                                            style: TextStyle(
                                                                fontSize: 17 *
                                                                    textScaleFactor),
                                                          ),
                                                          Text(
                                                            widget.modeList[
                                                                    index]
                                                                ? "Auto"
                                                                : "Manual",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20 *
                                                                    textScaleFactor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10 * textScaleFactor,
                                      ),
                                    ],
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
