import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:mqtt_client/mqtt_client.dart';

class Sensor1Page extends StatefulWidget {
  @override
  State<Sensor1Page> createState() => _Sensor1PageState();
}

class _Sensor1PageState extends State<Sensor1Page> {
  final StreamController<String> messageController =
      StreamController<String>.broadcast();
  @override
  void initState() {
    super.initState();
    _updateMQTT();
  }

  Future<void> _updateMQTT() async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message) ;
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
          backgroundColor: const Color.fromRGBO(250, 246, 229, 1),
          body: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 35,
                              color: Colors.grey[800],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 183),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.battery_std,
                                  size: 32,
                                  color: Colors.grey[700],
                                ),
                                StreamBuilder<String>(
                                  stream: messageController.stream,
                                  builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data != null ? snapshot.data!.split(',')[3] : "N/A"}%',
                                    style: TextStyle(
                                      fontSize: 23 * textScaleFactor,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //Humidity
                              SizedBox(
                                width: 350 * textScaleFactor,
                                height: 200 * textScaleFactor,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(42, 62, 54, 190),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Humidity",
                                          style: TextStyle(
                                            fontSize: 30 * textScaleFactor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Image.asset(
                                                "images/humidity.png",
                                                height: 95 * textScaleFactor,
                                                width: 95 * textScaleFactor,
                                              ),
                                            ),
                                            Text(
                                              "|",
                                              style: TextStyle(
                                                fontSize: 80 * textScaleFactor,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, right: 20),
                                              child: StreamBuilder<String>(
                                                stream:
                                                    messageController.stream,
                                                builder: (context, snapshot) {
                                                  return Text(
                                                    '${snapshot.data != null ? snapshot.data!.split(',')[0] : "N/A"}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          70 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              //Temperature
                              SizedBox(
                                width: 350,
                                height: 200,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(42, 62, 54, 190),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Temperature",
                                          style: TextStyle(
                                            fontSize: 30 * textScaleFactor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Image.asset(
                                                "images/temperature-sensor.png",
                                                height: 95 * textScaleFactor,
                                                width: 95 * textScaleFactor,
                                              ),
                                            ),
                                            Text(
                                              "|",
                                              style: TextStyle(
                                                fontSize: 80 * textScaleFactor,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, right: 20),
                                              child: StreamBuilder<String>(
                                                stream:
                                                    messageController.stream,
                                                builder: (context, snapshot) {
                                                  return Text(
                                                    '${snapshot.data != null ? snapshot.data!.split(',')[1] : "N/A"}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          70 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              //Light
                              SizedBox(
                                width: 350 * textScaleFactor,
                                height: 200 * textScaleFactor,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(42, 62, 54, 190),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Light",
                                          style: TextStyle(
                                            fontSize: 30 * textScaleFactor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10 * textScaleFactor),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Image.asset(
                                                "images/light.png",
                                                height: 100 * textScaleFactor,
                                                width: 100 * textScaleFactor,
                                              ),
                                            ),
                                            Text(
                                              "|",
                                              style: TextStyle(
                                                fontSize: 80 * textScaleFactor,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, right: 20),
                                              child: StreamBuilder<String>(
                                                stream:
                                                    messageController.stream,
                                                builder: (context, snapshot) {
                                                  return Text(
                                                    '${snapshot.data != null ? snapshot.data!.split(',')[2] : "N/A"}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          70 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
