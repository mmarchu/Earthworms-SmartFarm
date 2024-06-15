import 'dart:async';
import 'package:earthworms/HomeandData/HtimeSeries.dart';
import 'package:earthworms/HomeandData/TemtimeSeries.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';

// ignore: must_be_immutable
class SensorDetailPage extends StatefulWidget {
  final String nameSensor;
  final String macAddress;
  final String email;
  bool mode;
  bool power;

  SensorDetailPage(
      {required this.nameSensor,
      required this.macAddress,
      required this.email,
      required this.mode,
      required this.power});

  @override
  State<SensorDetailPage> createState() => _SensorDetailPageState();
}

class _SensorDetailPageState extends State<SensorDetailPage> {
  final StreamController<String> messageController =
      StreamController<String>.broadcast();
  late bool New_mode;
  late bool New_power;
  late String Mac_Address;

  @override
  void initState() {
    super.initState();
    _updateMQTT();
    New_mode = widget.mode;
    New_power = widget.power;
    Mac_Address = widget.macAddress;
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

  void _publishMQTT() {
    final builder = MqttClientPayloadBuilder();
    builder.addString('$Mac_Address,$New_mode,$New_power');
    //print('$M_A,$power');

    const topic = 'waterpump';
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final ScreenWidth = MediaQuery.of(context).size.width;
      final ScreenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight;
      final textScaleFactor = smallestDimension / 400;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(250, 246, 229, 1),
            body: Stack(
              children: [
                Container(
                  height: ScreenHeight,
                  color: Color(0xff0e4f55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 20 * textScaleFactor),
                          child: SizedBox(
                            width: ScreenWidth,
                            height: 140 * textScaleFactor,
                            child: Center(
                              child: AutoSizeText(
                                widget.nameSensor,
                                //'abcdefghigklmnopqrstuvwxyz1234567890987654321abcdefghijklmnopqrstuvwxyz',
                                style: TextStyle(
                                  fontSize: 35 * textScaleFactor,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(250, 246, 229, 1),
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                Positioned(
                  top: ScreenHeight * 0.15,
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
                          SizedBox(height: 25 * textScaleFactor),
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
                                                    HTimeSeriesPage()));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 15 * textScaleFactor,
                                          left: 15 * textScaleFactor,
                                          right: 15 * textScaleFactor,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8 * textScaleFactor),
                                                  child: Text(
                                                    "Humidity",
                                                    style: TextStyle(
                                                        fontSize: 19 *
                                                            textScaleFactor,
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
                                                    stream: messageController
                                                        .stream,
                                                    builder:
                                                        (context, snapshot) {
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TemtimeSeriesPage()));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 15 * textScaleFactor,
                                          left: 15 * textScaleFactor,
                                          right: 15 * textScaleFactor,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8 * textScaleFactor),
                                                  child: Text(
                                                    "Temperature",
                                                    style: TextStyle(
                                                        fontSize: 15 *
                                                            textScaleFactor,
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
                                                    stream: messageController
                                                        .stream,
                                                    builder:
                                                        (context, snapshot) {
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
                            height: 25 * textScaleFactor,
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
                                                      left:
                                                          27 * textScaleFactor),
                                                  child: CupertinoSwitch(
                                                    value: New_mode,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        New_mode = value;
                                                        if (value) {
                                                          New_power = false;
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
                                                      left:
                                                          18 * textScaleFactor),
                                                  child: CupertinoSwitch(
                                                      value: New_power,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (New_mode ==
                                                              false) {
                                                            New_power = value;
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
                ),
                // Back Bottom
                Positioned(
                    left: 40 * textScaleFactor,
                    bottom: 30 * textScaleFactor,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      heroTag: 'uniqueTag1',
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                      backgroundColor: Color(0xff0e4f55),
                    )),
                // Delete sensor Bottom
                Positioned(
                    right: 40 * textScaleFactor,
                    bottom: 30 * textScaleFactor,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      heroTag: 'uniqueTag2',
                      child: Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.white,
                      ),
                      backgroundColor: Color.fromARGB(255, 143, 48, 48),
                    )),
              ],
            )),
      );
    });
  }
}
