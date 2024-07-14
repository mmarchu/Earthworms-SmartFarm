import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TemtimeSeriesPage extends StatefulWidget {
  const TemtimeSeriesPage({super.key});

  @override
  State<TemtimeSeriesPage> createState() => _TemtimeSeriesPageState();
}

class _TemtimeSeriesPageState extends State<TemtimeSeriesPage> {
// Select Day
  void _selectDay(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      final json = {
        "period": "daily",
        "date": DateFormat('yyyy-MM-dd').format(selectedDate),
      };
      print(json);
      //_sendToApi(json);
    }
  }

//Select Week
  void _selectWeek(BuildContext context) async {
    final DateTime? selectedStartDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedStartDate != null) {
      final DateTime selectedEndDate = selectedStartDate.add(Duration(days: 6));
      final json = {
        "period": "weekly",
        "start": DateFormat('yyyy-MM-dd').format(selectedStartDate),
        "end": DateFormat('yyyy-MM-dd').format(selectedEndDate),
      };
      print(json);
      //_sendToApi(json);
    }
  }

//Select Month
  void _selectMonth(BuildContext context) async {
    final DateTime? selectedDate = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      final json = {
        "period": "monthly",
        "date": DateFormat('yyyy-MM').format(selectedDate),
      };
      print(json);
      //_sendToApi(json);
    }
  }

//Send Today to Api when open this page
  void _sendTodayToApi() {
    final today = DateTime.now();
    final json = {
      "period": "daily",
      "date": DateFormat('yyyy-MM-dd').format(today),
    };
    print(json);
    //_sendToApi(json);
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
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                top: 70 * textScaleFactor,
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
                                        "Temperature",
                                        style: TextStyle(
                                            fontSize: 28 * textScaleFactor,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ))
                      ],
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
                    topRight: Radius.circular(27),
                  ),
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
                                  top: 25 * textScaleFactor,
                                  right: 20 * textScaleFactor,
                                  left: 20 * textScaleFactor),
                              invertedSelection: true,
                              backgroundColor: Color.fromRGBO(250, 246, 229, 1),
                              foregroundColor: Color(0xff0e4f55),
                              borderColor: Colors.white,
                              innerVerticalPadding: 12,
                              children: [
                                ButtonBarEntry(
                                  child: Text(
                                    'Day',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () => _selectDay(context),
                                ),
                                ButtonBarEntry(
                                    child: Text(
                                      'Week',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () => _selectWeek(context)),
                                ButtonBarEntry(
                                    child: Text(
                                      'Month',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () => _selectMonth(context))
                              ],
                            )
                          ],
                        )
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
