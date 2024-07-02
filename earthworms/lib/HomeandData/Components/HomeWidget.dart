import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:earthworms/HomeandData/SensorDetailPage.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  final StreamController<String> messageController =
      StreamController<String>.broadcast();

  final String NameSensor;
  final String macAddress;
  final String email;
  final bool mode;
  final bool power;
  List<String> humidity;
  List<String> temp;

  HomeWidget(
      {required this.NameSensor,
      required this.macAddress,
      required this.email,
      required this.mode,
      required this.power,
      required this.humidity,
      required this.temp,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          screenWidth < screenHeight ? screenWidth : screenHeight;
      final textScaleFactor = smallestDimension / 400;
      return Column(
        children: [
          InkWell(
              onTap: () {
                print(NameSensor);
                print(macAddress);
                print('mode: $mode');
                print('power: $power');
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => SensorDetailPage(
                //               nameSensor: NameSensor,
                //               macAddress: macAddress,
                //               email: email,
                //               mode: mode,
                //               power: power,
                //             )));
              },
              child: SizedBox(
                width: 360 * textScaleFactor,
                height: 250 * textScaleFactor,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(232, 225, 198, 1),
                      borderRadius: BorderRadius.circular(27)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          NameSensor,
                          style: TextStyle(
                            fontSize: 23 * textScaleFactor,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        children: [
                          //Humidity
                          Padding(
                              padding: EdgeInsets.only(
                                left: 20 * textScaleFactor,
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 150 * textScaleFactor,
                                      height: 115 * textScaleFactor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          //boxShadow: [BoxShadow(blurRadius: 1)]
                                        ),
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
                                                        top: 8 *
                                                            textScaleFactor),
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
                                                    height:
                                                        28 * textScaleFactor,
                                                    width: 28 * textScaleFactor,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 20 *
                                                            textScaleFactor,
                                                        top: 6 *
                                                            textScaleFactor),
                                                    child:
                                                        StreamBuilder<String>(
                                                      stream: messageController
                                                          .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          //'${snapshot.data != null ? snapshot.data!.split(',')[1] : "N/A"}%',
                                                          '${humidity.isNotEmpty ? humidity.first : "N/A"}%',
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
                                    SizedBox(
                                      width: 20 * textScaleFactor,
                                    ),
                                    //Temperature
                                    SizedBox(
                                      width: 150 * textScaleFactor,
                                      height: 115 * textScaleFactor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          //boxShadow: [BoxShadow(blurRadius: 1)]
                                        ),
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
                                                        top: 8 *
                                                            textScaleFactor),
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
                                                    height:
                                                        20 * textScaleFactor,
                                                    width: 20 * textScaleFactor,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 20 *
                                                            textScaleFactor,
                                                        top: 13 *
                                                            textScaleFactor),
                                                    child:
                                                        StreamBuilder<String>(
                                                      stream: messageController
                                                          .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          //'${snapshot.data != null ? snapshot.data!.split(',')[2] : "N/A"}°C',
                                                          '${temp.isNotEmpty ? temp.first : "N/A"}°C',
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
                                  ]))
                        ],
                      ),
                      SizedBox(height: 20 * textScaleFactor),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(250, 246, 229, 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8 * textScaleFactor,
                                    top: 5 * textScaleFactor,
                                    bottom: 5 * textScaleFactor,
                                    right: 8 * textScaleFactor),
                                child: Image.asset("images/water-pump.png"),
                              ),
                              Text(
                                "Water Pump Mode: ",
                                style:
                                    TextStyle(fontSize: 17 * textScaleFactor),
                              ),
                              Text(
                                mode ? "Auto" : "Manual",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20 * textScaleFactor),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          SizedBox(
            height: 10 * textScaleFactor,
          ),
        ],
      );
    });
  }
}
