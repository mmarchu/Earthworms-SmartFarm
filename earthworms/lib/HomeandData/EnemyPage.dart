import 'dart:io';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:earthworms/HomeandData/Components/url.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:http/http.dart' as http;

class Enemypage extends StatefulWidget {
  const Enemypage({super.key});

  @override
  State<Enemypage> createState() => _EnemypageState();
}

class _EnemypageState extends State<Enemypage> {
  String enemySelect = '';

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
        "period": "monthly",
        "date": DateFormat('yyyy-MM').format(selectedDate),
      };
      final displayDate = DateFormat.MMMM('en_US').format(selectedDate);
      print(displayDate);
      _updateDateData(displayDate);
      //_sendDataToApi(json, 'Month');
    }
  }

// Send this month to Api
  void _SendThisMonthToApi() {
    final today = DateTime.now();
    final json = {
      //"sensor_id": widget.sensorId,
      "period": "monthly",
      "date": DateFormat('yyyy-MM').format(today),
    };
    final displayDate = DateFormat.MMMM('en_US').format(today);
    print(displayDate);
    _updateDateData(displayDate);
    // _sendDataToApi(json, 'Month');
  }

// update display Date
  void _updateDateData(String newDate) {
    setState(() {
      enemySelect = newDate;
    });
  }

//BarChart
  Widget _buildBarChart(double width, double height) {
    return Container(
      height: height,
      width: width,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(show: true),
          maxY: 10,
          // barGroups: _data.asMap().entries.map((entry) {
          //   int index = entry.key;
          //   var item = entry.value;

          //   return BarChartGroupData(
          //     x: index,
          //     barRods: [
          //       BarChartRodData(
          //         toY: item['y_humid'].toDouble(),
          //         color: Color(0xff0e4f55),
          //         width: 7,
          //       ),
          //     ],
          //   );
          // }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Hide right side titles
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final TitleMonth = {
                      0: '1',
                      4: '5',
                      8: '9',
                      12: '13',
                      16: '17',
                      20: '21',
                      24: '25',
                      28: '29'
                    };
                    String title = '';
                    title = TitleMonth[value.toInt()] ?? '';
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
                color: Colors.transparent, // Transparent border
                width: 0),
          ),
        ),
      ),
    );
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
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10 * textScaleFactor),
                                  child: Text(
                                    "Enemy Summary",
                                    style: TextStyle(
                                        fontSize: 28 * textScaleFactor,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20 * textScaleFactor),
                            Row(
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      if (Platform.isAndroid)
                                        _buildBarChart(375 * textScaleFactor,
                                            445 * textScaleFactor)
                                      else if (Platform.isIOS)
                                        _buildBarChart(380 * textScaleFactor,
                                            480 * textScaleFactor)
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.7,
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
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                          print('Rat');
                                        }),
                                    ButtonBarEntry(
                                        child: Text(
                                          'Toad',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          print('Toad');
                                        }),
                                    ButtonBarEntry(
                                        child: Text(
                                          'Skink',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          print('Skink');
                                        })
                                  ]),
                              SizedBox(height: 20 * textScaleFactor),
                              SizedBox(
                                width: 355 * textScaleFactor,
                                height: 43 * textScaleFactor,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(250, 246, 229, 1),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 340 * textScaleFactor,
                                          child: AutoSizeText(
                                            '< $enemySelect >',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20 * textScaleFactor),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20 * textScaleFactor,
                              ),
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
                                    border: Border.all(
                                        color: Colors.white, width: 1.3),
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
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ));
    });
  }
}
