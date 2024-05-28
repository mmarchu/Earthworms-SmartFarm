import 'dart:async';

import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StreamController<String> messageController =
      StreamController<String>.broadcast();

  final String NumSensor;
  final int Indexsensor;

  HomeWidget({required this.NumSensor, required this.Indexsensor, Key? key})
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
                print("Sensor ${Indexsensor}");
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
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          NumSensor,
                          style: TextStyle(
                              fontSize: 20 * textScaleFactor,
                              fontWeight: FontWeight.bold),
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
                                                          '${snapshot.data != null ? snapshot.data!.split(',')[1] : "N/A"}%',
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
                                                        top: 6 *
                                                            textScaleFactor),
                                                    child:
                                                        StreamBuilder<String>(
                                                      stream: messageController
                                                          .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          '${snapshot.data != null ? snapshot.data!.split(',')[2] : "N/A"}°C',
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
                        )),
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
