import 'dart:async';
import 'package:earthworms/HomeandData/waterpumpPage.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String lastname;

  HomePage({required this.name, required this.lastname});

  @override
  State<HomePage> createState() => _HomePageState();
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

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StreamController<String> messageController =
      StreamController<String>.broadcast();
  bool M_A = true;
  bool power = false;

  @override
  void initState() {
    super.initState();
    _updateMQTT();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _publishDefultMQTT();
  // }

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

  // void _publishDefultMQTT() {
  //   final builder = MqttClientPayloadBuilder();
  //   builder.addString('true,false');
  //   //print('$M_A,$power');

  //   const topic = 'waterpump';
  //   client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  // }

  void _publishMQTT() {
    final builder = MqttClientPayloadBuilder();
    builder.addString('$M_A,$power');
    //print('$M_A,$power');

    const topic = 'waterpump';
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
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
          backgroundColor: const Color(0xff0e4f55),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 65 * textScaleFactor, left: 40 * textScaleFactor),
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
                              padding:
                                  EdgeInsets.only(top: 2 * textScaleFactor),
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
                        padding: EdgeInsets.only(right: 30 * textScaleFactor),
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
                SizedBox(height: 15 * textScaleFactor),
                SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(250, 246, 229, 1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10 * textScaleFactor),
                          child: Text(
                            "THE EARTHWORM'S SMARTFARM",
                            style: TextStyle(
                                fontSize: 18 * textScaleFactor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20 * textScaleFactor,
                            // vertical: 40 * textScaleFactor
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Humidity
                              SizedBox(
                                width: 175 * textScaleFactor,
                                height: 140 * textScaleFactor,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(232, 225, 198, 1),
                                    borderRadius: BorderRadius.circular(25),
                                    //boxShadow: [BoxShadow(blurRadius: 1)]
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      print("Humidity");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  waterpumpPage()));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 17 * textScaleFactor,
                                        left: 15 * textScaleFactor,
                                        right: 15 * textScaleFactor,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8 * textScaleFactor),
                                                child: Text(
                                                  "Humidity",
                                                  style: TextStyle(
                                                      fontSize:
                                                          19 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Image.asset(
                                                "images/humidity.png",
                                                height: 40 * textScaleFactor,
                                                width: 40 * textScaleFactor,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        20 * textScaleFactor,
                                                    top: 6 * textScaleFactor),
                                                child: StreamBuilder<String>(
                                                  stream:
                                                      messageController.stream,
                                                  builder: (context, snapshot) {
                                                    return Text(
                                                      '${snapshot.data != null ? snapshot.data!.split(',')[1] : "N/A"}%',
                                                      style: TextStyle(
                                                        fontSize: 40 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                              ),
                              //Temperature
                              SizedBox(
                                width: 175 * textScaleFactor,
                                height: 140 * textScaleFactor,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(232, 225, 198, 1),
                                    borderRadius: BorderRadius.circular(25),
                                    //boxShadow: [BoxShadow(blurRadius: 1)]
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      print("temp");
                                      _logout();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 17 * textScaleFactor,
                                        left: 15 * textScaleFactor,
                                        right: 15 * textScaleFactor,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8 * textScaleFactor),
                                                child: Text(
                                                  "Temperature",
                                                  style: TextStyle(
                                                      fontSize:
                                                          15 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Image.asset(
                                                "images/temperature-sensor.png",
                                                height: 40 * textScaleFactor,
                                                width: 40 * textScaleFactor,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        20 * textScaleFactor,
                                                    top: 6 * textScaleFactor),
                                                child: StreamBuilder<String>(
                                                  stream:
                                                      messageController.stream,
                                                  builder: (context, snapshot) {
                                                    return Text(
                                                      '${snapshot.data != null ? snapshot.data!.split(',')[2] : "N/A"}°C',
                                                      style: TextStyle(
                                                        fontSize: 40 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 11 * textScaleFactor,
                        ),
                        // water pump
                        SizedBox(
                          width: 360 * textScaleFactor,
                          height: 140 * textScaleFactor,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(232, 225, 198, 1),
                              borderRadius: BorderRadius.circular(25),
                              //boxShadow: [BoxShadow(blurRadius: 1)]
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10 * textScaleFactor),
                                  child: Image.asset(
                                    "images/water-pump.png",
                                    height: 100 * textScaleFactor,
                                    width: 100 * textScaleFactor,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Switch auto/manual
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 13 * textScaleFactor,
                                              top: 30 * textScaleFactor),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Manual/Auto",
                                                style: TextStyle(
                                                  fontSize:
                                                      20 * textScaleFactor,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 27 * textScaleFactor),
                                                child: CupertinoSwitch(
                                                  value: M_A,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      M_A = value;
                                                      if (value) {
                                                        power = false;
                                                      }
                                                    });
                                                    _publishMQTT();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //Switch On/Off
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 14 * textScaleFactor,
                                            bottom: 25 * textScaleFactor,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Power off/ON",
                                                style: TextStyle(
                                                  fontSize:
                                                      20 * textScaleFactor,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 18 * textScaleFactor),
                                                child: CupertinoSwitch(
                                                    value: power,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        if (!M_A) {
                                                          power = value;
                                                        }
                                                      });
                                                      _publishMQTT();
                                                    }),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
