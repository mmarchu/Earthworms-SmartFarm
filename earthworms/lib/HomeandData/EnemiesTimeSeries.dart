import 'dart:convert';
import 'dart:io';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:earthworms/HomeandData/Components/url.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class EnemiesTimeSeries extends StatefulWidget {
  const EnemiesTimeSeries({super.key});

  @override
  State<EnemiesTimeSeries> createState() => _EnemiesTimeSeriesState();
}

Future<String?> loadData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

class _EnemiesTimeSeriesState extends State<EnemiesTimeSeries> {
  String dateSelect = '';
  String RatLog = '0';
  String ToadLog = '0';
  String LizardLog = '0';
  Map<String, double> dataMap = {};
  final ColorList = <Color>[
    Color.fromRGBO(121, 142, 164, 1),
    Color.fromRGBO(252, 126, 52, 1),
    Color.fromRGBO(2, 117, 144, 1)
  ];

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

            dataMap = {
              "Lizard": double.parse(LizardLog),
              "Rat": double.parse(RatLog),
              "Toad": double.parse(ToadLog),
            };
          });
          print(dataMap);
        } else {
          setState(() {
            dataMap = {};
          });
        }
      } else {
        print('${response.statusCode}: ${response.reasonPhrase}');
        setState(() {
          dataMap.clear();
        });
      }
    } catch (e) {
      Navigator.pop(context);
      print('Failed to connect to server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final ScreenWidth = MediaQuery.of(context).size.width;
      final ScreenHeight = MediaQuery.of(context).size.height;
      final smallestDiamension =
          ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight;
      final textScaleFactor = smallestDiamension / 400;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(250, 246, 229, 1),
          body: Container(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: ScreenHeight,
                    color: Color(0xff0e4f55),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 40 * textScaleFactor,
                          right: 25 * textScaleFactor,
                          child: TextButton(
                            onPressed: () {
                              print("edit month");
                              _selectMonth(context);
                            },
                            child: Text(
                              'Select',
                              style: TextStyle(
                                fontSize: 20 * textScaleFactor,
                                color: Color.fromRGBO(250, 246, 229, 1),
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Color.fromRGBO(250, 246, 229, 1),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 85 * textScaleFactor,
                          left: 10 * textScaleFactor,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 35,
                              color: Color.fromRGBO(250, 246, 229, 1),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 80 * textScaleFactor,
                              ),
                              child: SizedBox(
                                width: ScreenWidth,
                                height: 60 * textScaleFactor,
                                child: Center(
                                  child: AutoSizeText(
                                    dateSelect,
                                    style: TextStyle(
                                      fontSize: 35 * textScaleFactor,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(250, 246, 229, 1),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: ScreenHeight * 0.17,
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
                              Center(
                                child: dataMap.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            top: 2 * textScaleFactor),
                                        child: PieChart(
                                          dataMap: dataMap,
                                          animationDuration:
                                              Duration(milliseconds: 1000),
                                          chartLegendSpacing: 32,
                                          chartRadius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          colorList: ColorList,
                                          initialAngleInDegree: 0,
                                          chartType: ChartType.disc,
                                          ringStrokeWidth: 32,
                                          legendOptions: LegendOptions(
                                            showLegendsInRow: false,
                                            legendPosition:
                                                LegendPosition.right,
                                            showLegends: true,
                                            legendShape: BoxShape.circle,
                                            legendTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          chartValuesOptions:
                                              ChartValuesOptions(
                                                  showChartValueBackground:
                                                      true,
                                                  showChartValues: true,
                                                  showChartValuesInPercentage:
                                                      false,
                                                  showChartValuesOutside: false,
                                                  decimalPlaces: 0,
                                                  chartValueStyle: TextStyle(
                                                      fontSize:
                                                          16 * textScaleFactor,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ),
                                      )
                                    : Text('No data available'),
                              )
                            ],
                          ),
                        ),
                      )),
                  Positioned(
                      top: ScreenHeight * 0.5,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(27),
                              topRight: Radius.circular(27)),
                          child: Container(
                            color: Color(0xff0e4f55),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AnimatedButtonBar(
                                  radius: 16.0,
                                  padding: EdgeInsets.only(
                                      top: 20 * textScaleFactor,
                                      right: 20 * textScaleFactor,
                                      left: 20 * textScaleFactor),
                                  invertedSelection: true,
                                  backgroundColor:
                                      Color.fromRGBO(250, 246, 229, 1),
                                  foregroundColor: Color(0xff0e4f55),
                                  borderColor: Colors.white,
                                  innerVerticalPadding: 12,
                                  children: [
                                    ButtonBarEntry(
                                        child: Text(
                                          'Rat',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          print("Rat");
                                        }),
                                    ButtonBarEntry(
                                        child: Text(
                                          'Toad',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          print("Toad");
                                        }),
                                    ButtonBarEntry(
                                        child: Text(
                                          'Lizard',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          print("Lizard");
                                        })
                                  ],
                                )
                              ],
                            ),
                          )))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
