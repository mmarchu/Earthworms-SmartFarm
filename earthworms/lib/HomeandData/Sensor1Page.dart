import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Sensor1Page extends StatefulWidget {
  // List<double> data =[];

  // Sensor1Page({required this.data});

  @override
  State<Sensor1Page> createState() => _Sensor1PageState();
}

class _Sensor1PageState extends State<Sensor1Page> {
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
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
                                          color:
                                              Color.fromRGBO(42, 62, 54, 190),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text("Humidity",
                                                style: TextStyle(
                                                    fontSize:
                                                        30 * textScaleFactor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, top: 10),
                                                  child: Image.asset(
                                                    "images/humidity.png",
                                                    height:
                                                        95 * textScaleFactor,
                                                    width: 95 * textScaleFactor,
                                                  ),
                                                ),
                                                Text(
                                                  "|",
                                                  style: TextStyle(
                                                      fontSize:
                                                          80 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, right: 20),
                                                  child: Text(
                                                    "25",
                                                    style: TextStyle(
                                                        fontSize: 70 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                )
                                              ],
                                            )
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
                                          color:
                                              Color.fromRGBO(42, 62, 54, 190),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text("Temperature",
                                                style: TextStyle(
                                                    fontSize:
                                                        30 * textScaleFactor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Image.asset(
                                                    "images/temperature-sensor.png",
                                                    height:
                                                        95 * textScaleFactor,
                                                    width: 95 * textScaleFactor,
                                                  ),
                                                ),
                                                Text(
                                                  "|",
                                                  style: TextStyle(
                                                      fontSize:
                                                          80 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, right: 20),
                                                  child: Text(
                                                    "25",
                                                    style: TextStyle(
                                                        fontSize: 70 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                )
                                              ],
                                            )
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
                                          color:
                                              Color.fromRGBO(42, 62, 54, 190),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text("Light",
                                                style: TextStyle(
                                                    fontSize:
                                                        30 * textScaleFactor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: 10 * textScaleFactor,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Image.asset(
                                                    "images/light.png",
                                                    height:
                                                        100 * textScaleFactor,
                                                    width:
                                                        100 * textScaleFactor,
                                                  ),
                                                ),
                                                Text(
                                                  "|",
                                                  style: TextStyle(
                                                      fontSize:
                                                          80 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, right: 20),
                                                  child: Text(
                                                    "25",
                                                    style: TextStyle(
                                                        fontSize: 70 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                )
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
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )));
    });
  }
}

Future<void> connectMQTT() async {
  final client = MqttServerClient(
      'e076141ea6a943a5b775dae136735d83.s1.eu.hivemq.cloud', '8883');
  client.port = 8883;
  client.logging(on: false);
  client.keepAlivePeriod = 60;
  final SecurityContext securityContext = SecurityContext.defaultContext;
  securityContext.setTrustedCertificates('message-2.txt');
  client.secure = true;
  client.securityContext = securityContext;

  final connMess = MqttConnectMessage()
      .authenticateAs('march', 'Third0804151646')
      .withClientIdentifier('dart_client')
      .withWillTopic('flora_detail')
      .withWillMessage('My Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);

  print('Client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('Client exception: $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('Socket exception: $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('Client connected');
  } else {
    print(
        'Client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  const subTopic = 'flora_detail';
  print('Subscribing to the $subTopic topic');
  client.subscribe(subTopic, MqttQos.atMostOnce);
  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    // Provider.of<PtProvider>(context, listen: false).setPt(pt);
    print('Received message: topic is ${c[0].topic}, payload is $pt');
  });

  const pubTopic = 'flora_detail';
  final builder = MqttClientPayloadBuilder();
  builder.addString('Hello from mqtt_client');

  print('Subscribing to the $pubTopic topic');
  client.subscribe(pubTopic, MqttQos.exactlyOnce);

  print('Publishing our topic');
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

  print('Sleeping....');
  await MqttUtilities.asyncSleep(80);
}
