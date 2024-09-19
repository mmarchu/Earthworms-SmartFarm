import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:earthworms/HomeandData/Components/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Enemylogpage extends StatefulWidget {
  const Enemylogpage({super.key});

  @override
  State<Enemylogpage> createState() => _EnemylogpageState();
}

Future<String?> loadData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

class _EnemylogpageState extends State<Enemylogpage> {
  String dateSelect = '';
  String RatLog = '0';
  String ToadLog = '0';
  String LizardLog = '0';

  @override
  void initState() {
    super.initState();
    _SendThisMonthToApi();
  }

// Select Month
  void _selectMonth(BuildContext context) async {
    final DateTime? selectedDate = await showMonthPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
        headerColor: Color(0xff0e4f55),
        selectedMonthTextColor: Color.fromRGBO(250, 246, 229, 1),
        unselectedMonthTextColor: Color(0xff0e4f55),
        selectedMonthBackgroundColor: Color(0xff0e4f55),
        confirmWidget: Text(
          "Next",
          style: TextStyle(
            color: Color(0xff0e4f55),
          ),
        ),
        cancelWidget: Text(
          "Cancel",
          style: TextStyle(
            color: Color(0xff0e4f55),
          ),
        ));

    if (selectedDate != null) {
      final json = {
        //"sensor_id": widget.sensorId,
        //"period": "monthly",
        "date": DateFormat('yyyy-MM-dd').format(selectedDate),
      };
      final displayDate = DateFormat.MMMM('en_US').format(selectedDate);
      print(displayDate);
      _updateDateData(displayDate);
      _sendDataToApi(json);
    }
  }

// Send this month to Api
  void _SendThisMonthToApi() {
    final today = DateTime.now();
    final json = {
      //"sensor_id": widget.sensorId,
      //"period": "monthly",
      "date": DateFormat('yyyy-MM-dd').format(today),
    };
    final displayDate = DateFormat.MMMM('en_US').format(today);
    print(displayDate);
    _updateDateData(displayDate);
    _sendDataToApi(json);
  }

// update display Date
  void _updateDateData(String newDate) {
    setState(() {
      dateSelect = newDate;
    });
  }

// send month for get data
  Future<void> _sendDataToApi(final json) async {
    String? token = await loadData('Token');
    var url;

    if (Platform.isAndroid) {
      url = ApiUrl.ANDGetLogEnemies;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSGetLogEnemies;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 300,
            height: 100,
            child: Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Color(0xff0e4f55),
                size: 50,
              ),
            ),
          ),
        );
      },
    );

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charest=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(json));

      Navigator.pop(context);

      if (response.statusCode == 200) {
        final JsonData = jsonDecode(response.body) as List<dynamic>;
        if (JsonData.isNotEmpty) {
          final data = JsonData[0] as Map<String, dynamic>;
          setState(() {
            RatLog = data['Rat'].toString();
            ToadLog = data['Toad'].toString();
            LizardLog = data['Lizard'].toString();
          });
        }
      } else {
        print('${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      Navigator.pop(context);
      print('Failed to connect to server: $e');
    }
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
          backgroundColor: Color.fromRGBO(250, 246, 229, 1),
          body: Stack(
            children: [
              Container(
                height: screenHeight,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 55 * textScaleFactor,
                          left: 10 * textScaleFactor),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 35,
                                    color: Colors.grey[800],
                                  )),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10 * textScaleFactor),
                                child: Text(
                                  'Enemies Summery',
                                  style: TextStyle(
                                      fontSize: 28 * textScaleFactor,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10 * textScaleFactor),
                        ],
                      ),
                    ),
                    //Rat
                    SizedBox(
                      width: 350 * textScaleFactor,
                      height: 175 * textScaleFactor,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(232, 225, 198, 1),
                          borderRadius: BorderRadius.circular(27),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 350 * textScaleFactor,
                                height: 35 * textScaleFactor,
                                child: Center(
                                  child: Text(
                                    'Rat',
                                    style: TextStyle(
                                        fontSize: 30 * textScaleFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3 * textScaleFactor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 17 * textScaleFactor),
                                  child: SizedBox(
                                    width: 150 * textScaleFactor,
                                    height: 100 * textScaleFactor,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/rats.png',
                                            height: 85 * textScaleFactor,
                                            width: 85 * textScaleFactor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 17 * textScaleFactor),
                                  child: SizedBox(
                                    width: 150 * textScaleFactor,
                                    height: 100 * textScaleFactor,
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                250, 246, 229, 1),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              RatLog,
                                              style: TextStyle(
                                                  fontSize:
                                                      50 * textScaleFactor,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15 * textScaleFactor),

                    //Toad
                    SizedBox(
                      width: 350 * textScaleFactor,
                      height: 175 * textScaleFactor,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(232, 225, 198, 1),
                          borderRadius: BorderRadius.circular(27),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 350 * textScaleFactor,
                                height: 35 * textScaleFactor,
                                child: Center(
                                  child: Text(
                                    "Toad",
                                    style: TextStyle(
                                        fontSize: 30 * textScaleFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3 * textScaleFactor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 17 * textScaleFactor),
                                  child: SizedBox(
                                    width: 150 * textScaleFactor,
                                    height: 100 * textScaleFactor,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/toad.png',
                                            height: 75 * textScaleFactor,
                                            width: 75 * textScaleFactor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 17 * textScaleFactor),
                                  child: SizedBox(
                                    width: 150 * textScaleFactor,
                                    height: 100 * textScaleFactor,
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                250, 246, 229, 1),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ToadLog,
                                              style: TextStyle(
                                                  fontSize:
                                                      50 * textScaleFactor,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15 * textScaleFactor),

                    //Skink
                    SizedBox(
                      width: 350 * textScaleFactor,
                      height: 175 * textScaleFactor,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(232, 225, 198, 1),
                          borderRadius: BorderRadius.circular(27),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 350 * textScaleFactor,
                                height: 35 * textScaleFactor,
                                child: Center(
                                  child: Text(
                                    'Lizard',
                                    style: TextStyle(
                                        fontSize: 30 * textScaleFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3 * textScaleFactor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 17 * textScaleFactor),
                                  child: SizedBox(
                                    width: 150 * textScaleFactor,
                                    height: 100 * textScaleFactor,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 246, 229, 1),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/skink.png',
                                            height: 75 * textScaleFactor,
                                            width: 75 * textScaleFactor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 17 * textScaleFactor),
                                  child: SizedBox(
                                    width: 150 * textScaleFactor,
                                    height: 100 * textScaleFactor,
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                250, 246, 229, 1),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              LizardLog,
                                              style: TextStyle(
                                                  fontSize:
                                                      50 * textScaleFactor,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * 0.79,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(27),
                    topRight: Radius.circular(27),
                  ),
                  child: Container(
                    color: Color(0xff0e4f55),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 355 * textScaleFactor,
                          height: 43 * textScaleFactor,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(250, 246, 229, 1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 340 * textScaleFactor,
                                    child: AutoSizeText(
                                      '< $dateSelect >',
                                      style: TextStyle(
                                          fontSize: 20 * textScaleFactor,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 23 * textScaleFactor),
                        InkWell(
                          onTap: () {
                            _selectMonth(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(239, 165, 38, 1),
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.white, width: 1.3),
                            ),
                            child: Center(
                              child: Text(
                                'Select Month',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
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
      );
    });
  }
}
