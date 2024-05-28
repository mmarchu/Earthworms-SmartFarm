import 'package:earthworms/All/Sensor2Page.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
// import 'package:earthworms/All/Sensor1Page.dart';
// import 'package:earthworms/All/statisPage.dart';
import 'package:earthworms/All/waterpumpPage.dart';
import 'package:earthworms/NewHomePage/TimeSeries.dart';
import 'package:earthworms/TestFunc/Sensor2Responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:mqtt_client/mqtt_client.dart';

class Newhomepage extends StatefulWidget {
  final String email;
  final String name;
  final String lastname;

  Newhomepage(
      {required this.email, required this.name, required this.lastname});

  @override
  State<Newhomepage> createState() => _NewhomepageState();
}

// Delete Token in SharePref
Future<void> removeData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

void _logout() async {
  await removeData('Token');
  print("Log out");
}

class _NewhomepageState extends State<Newhomepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StreamController<String> messageController =
      StreamController<String>.broadcast();
  List<String> sensorData = [];

  @override
  void initState() {
    super.initState();
    _updateMQTT();
  }

  Future<void> _updateMQTT() async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        messageController.add(pt);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          screenWidth < screenHeight ? screenWidth : screenHeight;
      final textScaleFactor = smallestDimension / 400;
      return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Color.fromRGBO(250, 246, 229, 1),

            //navigation drawer
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(42, 62, 54, 1),
                      ),
                      child: UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 1)),
                        // Name Header
                        accountName: Text(
                          widget.name + " " + widget.lastname,
                          style: TextStyle(
                            fontSize: 18 * textScaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        // Email Header
                        accountEmail: Text(
                          widget.email,
                          style: TextStyle(
                              fontSize: 16 * textScaleFactor,
                              color: Colors.white),
                        ),
                      )),
                  ListTile(
                    title: Text(
                      'Log out',
                      style: TextStyle(fontSize: 18 * textScaleFactor),
                    ),
                    onTap: () {
                      _logout();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ],
              ),
            ),

            body: SafeArea(
                child: Column(
              children: [
                //appBar
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25 * textScaleFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // icon Menu
                      IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                            print('Menu');
                          },
                          icon: Icon(
                            Icons.menu,
                            size: 35 * textScaleFactor,
                            color: Colors.grey[800],
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 15 * textScaleFactor),

                // text Header
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 35 * textScaleFactor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "The Earthworms SmartFarm",
                            style: TextStyle(
                              fontSize: 23 * textScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10 * textScaleFactor,
                        ),
                      ],
                    )),
                SizedBox(height: 15 * textScaleFactor),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20 * textScaleFactor,
                    //vertical: 10 * textScaleFactor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Sensor1
                      SizedBox(
                        width: 172 * textScaleFactor,
                        height: 300 * textScaleFactor,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(232, 225, 198, 1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(blurRadius: 1)],
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  print('Sensor1');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TimeSeries()));
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 40 * textScaleFactor,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8 * textScaleFactor),
                                            child: Center(
                                                child: Text(
                                              'SENSOR 1',
                                              style: TextStyle(
                                                  fontSize:
                                                      18 * textScaleFactor,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800]),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),

                                    //Humidity
                                    SizedBox(
                                      width: 145 * textScaleFactor,
                                      height: 70 * textScaleFactor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 6),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "images/humidity.png",
                                                height: 38 * textScaleFactor,
                                                width: 38 * textScaleFactor,
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text(
                                                      "Humidity",
                                                      style: TextStyle(
                                                          fontSize: 13 *
                                                              textScaleFactor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child:
                                                        StreamBuilder<String>(
                                                      stream: messageController
                                                          .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          '${snapshot.data != null ? snapshot.data!.split(',')[1] : "N/A"}',
                                                          style: TextStyle(
                                                            fontSize: 27 *
                                                                textScaleFactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        );
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
                                      height: 15 * textScaleFactor,
                                    ),

                                    //Temperature
                                    SizedBox(
                                      width: 145 * textScaleFactor,
                                      height: 70 * textScaleFactor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          //boxShadow: [BoxShadow(blurRadius: 0.1)]
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(top: 6, left: 10),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "images/temperature-sensor.png",
                                                height: 40 * textScaleFactor,
                                                width: 40 * textScaleFactor,
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 1),
                                                    child: Text(
                                                      "Temperature",
                                                      style: TextStyle(
                                                          fontSize: 12 *
                                                              textScaleFactor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 3, top: 4),
                                                    child:
                                                        StreamBuilder<String>(
                                                      stream: messageController
                                                          .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          '${snapshot.data != null ? snapshot.data!.split(',')[2] : "N/A"}°C',
                                                          style: TextStyle(
                                                            fontSize: 22 *
                                                                textScaleFactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        );
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
                                      height: 15 * textScaleFactor,
                                    ),

                                    //Light
                                    SizedBox(
                                      width: 145 * textScaleFactor,
                                      height: 70 * textScaleFactor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          //boxShadow: [BoxShadow(blurRadius: 0.1)]
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 6),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "images/light.png",
                                                height: 40 * textScaleFactor,
                                                width: 40 * textScaleFactor,
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                      "Light",
                                                      style: TextStyle(
                                                          fontSize: 13 *
                                                              textScaleFactor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18, top: 5),
                                                    child:
                                                        StreamBuilder<String>(
                                                      stream: messageController
                                                          .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          '${snapshot.data != null ? snapshot.data!.split(',')[3] : "N/A"}',
                                                          style: TextStyle(
                                                            fontSize: 25 *
                                                                textScaleFactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        );
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sensor2
                      SizedBox(
                        width: 172 * textScaleFactor,
                        height: 300 * textScaleFactor,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(232, 225, 198, 1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(blurRadius: 1)],
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  print('Sensor2');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Sensor2Page()));
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 40 * textScaleFactor,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8 * textScaleFactor),
                                            child: Center(
                                                child: Text(
                                              'SENSOR 2',
                                              style: TextStyle(
                                                  fontSize:
                                                      18 * textScaleFactor,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800]),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),

                                    //Humidity
                                    SizedBox(
                                      width: 145 * textScaleFactor,
                                      height: 70 * textScaleFactor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 6),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "images/humidity.png",
                                                height: 38 * textScaleFactor,
                                                width: 38 * textScaleFactor,
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text(
                                                      "Humidity",
                                                      style: TextStyle(
                                                          fontSize: 13 *
                                                              textScaleFactor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child:
                                                        StreamBuilder<String>(
                                                      stream: messageController
                                                          .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          '${snapshot.data != null ? snapshot.data!.split(',')[6] : "N/A"}',
                                                          style: TextStyle(
                                                            fontSize: 27 *
                                                                textScaleFactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        );
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
                                      height: 15 * textScaleFactor,
                                    ),

                                    //Temperature
                                    SizedBox(
                                      width: 145 * textScaleFactor,
                                      height: 70 * textScaleFactor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          //boxShadow: [BoxShadow(blurRadius: 0.1)]
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(top: 6, left: 10),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "images/temperature-sensor.png",
                                                height: 40 * textScaleFactor,
                                                width: 40 * textScaleFactor,
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 1),
                                                    child: Text(
                                                      "Temperature",
                                                      style: TextStyle(
                                                          fontSize: 12 *
                                                              textScaleFactor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 3, top: 4),
                                                    child:
                                                        StreamBuilder<String>(
                                                      stream: messageController
                                                          .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          '${snapshot.data != null ? snapshot.data!.split(',')[7] : "N/A"}°C',
                                                          style: TextStyle(
                                                            fontSize: 22 *
                                                                textScaleFactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        );
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
                                      height: 15 * textScaleFactor,
                                    ),

                                    //Light
                                    SizedBox(
                                      width: 145 * textScaleFactor,
                                      height: 70 * textScaleFactor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          //boxShadow: [BoxShadow(blurRadius: 0.1)]
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 6),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "images/light.png",
                                                height: 40 * textScaleFactor,
                                                width: 40 * textScaleFactor,
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                      "Light",
                                                      style: TextStyle(
                                                          fontSize: 13 *
                                                              textScaleFactor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18, top: 5),
                                                    child:
                                                        StreamBuilder<String>(
                                                      stream: messageController
                                                          .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          '${snapshot.data != null ? snapshot.data!.split(',')[8] : "N/A"}',
                                                          style: TextStyle(
                                                            fontSize: 25 *
                                                                textScaleFactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        );
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20 * textScaleFactor,
                      vertical: 10 * textScaleFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Water Pump
                      SizedBox(
                        width: 172 * textScaleFactor,
                        height: 200 * textScaleFactor,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(42, 62, 54, 1),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(blurRadius: 1)]),
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                print('Water Pump');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => waterpumpPage()));
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 25 * textScaleFactor,
                                  ),
                                  Image.asset(
                                    "images/water-pump-1.png",
                                    width: 100 * textScaleFactor,
                                    height: 100 * textScaleFactor,
                                  ),
                                  SizedBox(
                                    height: 20 * textScaleFactor,
                                  ),
                                  Text(
                                    'Water Pump',
                                    style: TextStyle(
                                      fontSize: 20 * textScaleFactor,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),

                      //Stats Page
                      SizedBox(
                        width: 172 * textScaleFactor,
                        height: 200 * textScaleFactor,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(42, 62, 54, 1),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(blurRadius: 1)]),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  print('Stats Web');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TimeSE1()));
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 20 * textScaleFactor,
                                    ),
                                    Image.asset(
                                      "images/StatsIcons.png",
                                      height: 100 * textScaleFactor,
                                      width: 100 * textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 15 * textScaleFactor,
                                    ),
                                    Text(
                                      'Summary',
                                      style: TextStyle(
                                          fontSize: 20 * textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Report',
                                      style: TextStyle(
                                          fontSize: 20 * textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          ));
    });
  }
}
