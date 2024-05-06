import 'dart:async';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:mqtt_client/mqtt_client.dart';

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
                  child: Column(
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
                          padding: EdgeInsets.only(top: 2 * textScaleFactor),
                          child: Text(
                            widget.lastname,
                            style: TextStyle(
                                fontSize: 30 * textScaleFactor,
                                fontWeight: FontWeight.bold,
                                color:
                                    const Color.fromARGB(255, 213, 205, 205)),
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
                          padding: const EdgeInsets.all(15.0),
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
                                height: 160 * textScaleFactor,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(232, 225, 198, 1),
                                    borderRadius: BorderRadius.circular(25),
                                    //boxShadow: [BoxShadow(blurRadius: 1)]
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      print("Humidity");
                                    },
                                  ),
                                ),
                              ),
                              //Temperature
                              SizedBox(
                                width: 175 * textScaleFactor,
                                height: 160 * textScaleFactor,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(232, 225, 198, 1),
                                    borderRadius: BorderRadius.circular(25),
                                    //boxShadow: [BoxShadow(blurRadius: 1)]
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      print("Temperature");
                                      _logout();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    },
                                  ),
                                ),
                              ),
                            ],
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
