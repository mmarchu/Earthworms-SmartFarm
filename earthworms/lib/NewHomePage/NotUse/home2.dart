import 'dart:async';
// import 'dart:ffi';
// import 'package:earthworms/All/waterpumpPage.dart';
// import 'package:earthworms/MainFunction/LoginPage.dart';
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

//Func. Logout
void _logout() async {
  await removeData('Token');
  print("Log out");
}

class _HomePageState extends State<HomePage> {
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StreamController<String> messageController =
      StreamController<String>.broadcast();
  bool M_A = true;
  bool power = false;
  TextEditingController lastnameController = TextEditingController();
  int SensorCount = 3;

  @override
  void initState() {
    super.initState();
    _updateMQTT();
  }

//Get data from sensor by MQTT
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

//Public pump data to MQTT
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
            backgroundColor: Color(0xff0e4f55),
            bottomNavigationBar: SafeArea(
              child: Container(
                width: 36,
                height: 36,
                color: Color(0xff0e4f55),
              ),
            ),
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
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth,
                        height: screenHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(250, 246, 229, 1),
                            borderRadius: BorderRadius.circular(27),
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
                              // ListView.builder(
                              //   itemCount: 6,
                              //   itemBuilder: (context, index) {
                              //     return Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child:
                              //             HomeWidget(NumSensor: "Sensor ${index + 1}")
                              //             );
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
