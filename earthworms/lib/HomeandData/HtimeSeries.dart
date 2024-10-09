import 'dart:convert';
import 'dart:io';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:earthworms/HomeandData/Components/url.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HTimeSeriesPage extends StatefulWidget {
  final String sensorId;
  HTimeSeriesPage({required this.sensorId});

  @override
  State<HTimeSeriesPage> createState() => _HTimeSeriesPageState();
}

Future<String?> loadData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

class _HTimeSeriesPageState extends State<HTimeSeriesPage> {
  String selectedPeriod = '';
  List<dynamic> _data = [];
  late String period;
  String dateSelect = '';

  @override
  void initState() {
    _sendTodayToApi();
    super.initState();
  }

// Select Day
  void _selectDay(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                    primary: Color(0xff0e4f55)), // selection color
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary, // button text color
                ),
              ),
              child: child!);
        });

    if (selectedDate != null) {
      final json = {
        "sensor_id": widget.sensorId,
        "period": "daily",
        "date": DateFormat('yyyy-MM-dd').format(selectedDate),
      };
      final displayDate =
          DateFormat('EEE, MMM d, ' 'yyyy').format(selectedDate);
      print(displayDate);
      _updateDateData(displayDate);
      //print(json);
      _sendDataToApi(json, 'Day');
    }
  }

// Select Week
  void _selectWeek(BuildContext context) async {
    final DateTime? selectedStartDate = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                    primary: Color(0xff0e4f55)), // selection color
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary, // button text color
                ),
              ),
              child: child!);
        });

    if (selectedStartDate != null) {
      final DateTime selectedEndDate = selectedStartDate.add(Duration(days: 6));
      final json = {
        "sensor_id": widget.sensorId,
        "period": "weekly",
        "start": DateFormat('yyyy-MM-dd').format(selectedStartDate),
        "end": DateFormat('yyyy-MM-dd').format(selectedEndDate),
      };
      print(json);
      _sendDataToApi(json, 'Week');

      final displayStartDate =
          DateFormat('EEE, MMM d, ' 'yyyy').format(selectedStartDate);
      final DisplayEndDayBefore =
          DateFormat('EEE, MMM d, ' 'yyyy').format(selectedEndDate);
      final dateSevenDay = '$displayStartDate - $DisplayEndDayBefore';
      print(dateSevenDay);
      _updateDateData(dateSevenDay);
    }
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
        "sensor_id": widget.sensorId,
        "period": "monthly",
        "date": DateFormat('yyyy-MM-dd').format(selectedDate),
      };
      final displayDate = DateFormat.MMMM('en_US').format(selectedDate);
      print(displayDate);
      _updateDateData(displayDate);
      //print(json);
      _sendDataToApi(json, 'Month');
    }
  }

// Select Year
  void _selectYear(BuildContext context) async {
    int selectedYear = DateTime.now().year;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Year'),
          content: Container(
            height: 300,
            width: 300,
            child: Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color(0xff0e4f55),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: YearPicker(
                firstDate: DateTime(2020),
                lastDate: DateTime(2024),
                selectedDate: DateTime(selectedYear),
                onChanged: (DateTime dateTime) {
                  setState(() {
                    selectedYear = dateTime.year;
                  });
                  Navigator.pop(context);

                  final json = {
                    "sensor_id": widget.sensorId,
                    "period": "year",
                    "date": selectedYear.toString(),
                  };
                  final displayDate = "Year : ${selectedYear}";
                  print(displayDate);
                  _updateDateData(displayDate);
                  _sendDataToApi(json, 'Year');
                },
              ),
            ),
          ),
        );
      },
    );
  }

// Send Today to Api when open this page
  void _sendTodayToApi() {
    final today = DateTime.now();
    final json = {
      "sensor_id": widget.sensorId,
      "period": "daily",
      "date": DateFormat('yyyy-MM-dd').format(today),
    };
    //final displayDate = DateFormat('dd - MM - yyyy').format(today);
    final displayDate = DateFormat('EEE, MMM d, ' 'yyyy').format(today);
    print(displayDate);
    _updateDateData(displayDate);
    _sendDataToApi(json, 'Day');
    _updateSelectedBottom('Select Day');
  }

// Send This week to Api when open this page
  void _sendThisWeekToApi() {
    final today = DateTime.now();
    final SixDayBefore = today.subtract(Duration(days: 6));
    final json = {
      "sensor_id": widget.sensorId,
      "period": "weekly",
      "start": DateFormat('yyyy-MM-dd').format(SixDayBefore),
      "end": DateFormat('yyyy-MM-dd').format(today),
    };

    final displayDate = DateFormat('EEE, MMM d, ' 'yyyy').format(today);
    final DisplaySixDayBefore =
        DateFormat('EEE, MMM d, ' 'yyyy').format(SixDayBefore);
    final dateSevenDay = '$DisplaySixDayBefore - $displayDate';
    print(dateSevenDay);
    _updateDateData(dateSevenDay);
    _sendDataToApi(json, 'Week');
    _updateSelectedBottom('Select Week');
  }

// Send This month to Api
  void _SendThisMonthToApi() {
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    final json = {
      "sensor_id": widget.sensorId,
      "period": "monthly",
      "date": DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
    };
    final displayDate = DateFormat.MMMM('en_US').format(today);
    print(displayDate);
    _updateDateData(displayDate);
    _sendDataToApi(json, 'Month');
  }

// Send This year to Api
  void _sendThisYearToApi() {
    int selectedYear = DateTime.now().year;
    final json = {
      "sensor_id": widget.sensorId,
      "period": "year",
      "date": selectedYear.toString(),
    };
    final displayDate = "Year : ${selectedYear}";
    print(displayDate);
    _updateDateData(displayDate);
    _sendDataToApi(json, 'Year');
  }

// Api Get Data
  Future<void> _sendDataToApi(final json, String _period) async {
    String? token = await loadData('Token');
    var url;

    if (Platform.isAndroid) {
      url = ApiUrl.ANDgetTimeseries;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSgetTimeseries;
    }

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(json));

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        print('Decoded Data: $decodedData');
        setState(() {
          _data = decodedData;
          period = _period;
          if (_period == 'Day') {
            _data = List.generate(24, (index) {
              final String x = index.toString().padLeft(2, '0');
              final data = decodedData.firstWhere((item) => item['x'] == x,
                  orElse: () => {"x": x, "avg_humidity": 0});
              return data;
            });
          } else if (_period == 'Month') {
            _data = List.generate(30, (index) {
              final String x = (index + 1).toString().padLeft(2, '0');
              final data = decodedData.firstWhere((item) => item['x'] == x,
                  orElse: () => {"x": x, "avg_humidity": 0});
              return data;
            });
          } else if (_period == 'Year') {
            _data = List.generate(12, (index) {
              final String x = index.toString().padLeft(2, '0');
              final data = decodedData.firstWhere((item) => item['x'] == x,
                  orElse: () => {"x": x, "avg_humidity": 0});
              return data;
            });
          }
        });
      } else if (response.statusCode == 404) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('No data available'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _data.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Try Again",
                          style: TextStyle(color: Color(0xff0e4f55))))
                ],
              );
            });
      } else {
        print('${response.statusCode}: ${response.reasonPhrase}');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ERROR!'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _data.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Try Again",
                          style: TextStyle(color: Color(0xff0e4f55))))
                ],
              );
            });
      }
    } catch (e) {
      print('Failed to connect to server: $e');
    }
  }

// Update bottom period
  void _updateSelectedBottom(String newText) {
    setState(() {
      selectedPeriod = newText;
    });
  }

// update display Date
  void _updateDateData(String newDate) {
    setState(() {
      dateSelect = newDate;
    });
  }

// BarChart
  Widget _buildBarChart(double width, double height) {
    return Container(
      height: height,
      width: width,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(show: false),
          maxY: 100,
          barGroups: _data.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item['avg_humidity']?.toDouble() ?? 0.0,
                  color: Color(0xff0e4f55),
                  width: 7,
                ),
              ],
            );
          }).toList(),
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
                    final TitleDay = {
                      0: '12☾',
                      6: '6',
                      12: '  12𖤓',
                      18: '18',
                      23: '23'
                    };
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
                    final TitleYear = {
                      0: '1',
                      1: '2',
                      2: '3',
                      3: '4',
                      4: '5',
                      5: '6',
                      6: '7',
                      7: '8',
                      8: '9',
                      9: '10',
                      10: '11',
                      11: '12'
                    };
                    String title = '';
                    if (period == 'Day') {
                      title = TitleDay[value.toInt()] ?? '';
                    } else if (period == 'Week') {
                      if (value.toInt() < _data.length) {
                        title = _data[value.toInt()]['x'].toString();
                      }
                    } else if (period == 'Month') {
                      title = TitleMonth[value.toInt()] ?? '';
                    } else {
                      title = TitleYear[value.toInt()] ?? '';
                    }
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
          extraLinesData: ExtraLinesData(horizontalLines: [
            HorizontalLine(
                y: 40, color: Colors.red, strokeWidth: 3, dashArray: [25, 5]),
            HorizontalLine(
                y: 80, color: Colors.red, strokeWidth: 3, dashArray: [25, 5]),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          screenWidth < screenHeight ? screenWidth : screenHeight;
      final textScaleFactor = smallestDimension / 400;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(250, 246, 229, 1),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: screenHeight,
                  child: Column(
                    children: [
                      Row(
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
                                        "Humidity",
                                        style: TextStyle(
                                            fontSize: 28 * textScaleFactor,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15 * textScaleFactor),
                      SizedBox(
                        width: 355 * textScaleFactor,
                        height: 43 * textScaleFactor,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              //color: Color.fromRGBO(199, 171, 42, 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 340 * textScaleFactor,
                                  child: AutoSizeText(
                                    dateSelect,
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30 * textScaleFactor),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30 * textScaleFactor),
                      Row(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                if (Platform.isAndroid)
                                  _buildBarChart(375 * textScaleFactor,
                                      480 * textScaleFactor)
                                else if (Platform.isIOS)
                                  _buildBarChart(380 * textScaleFactor,
                                      493 * textScaleFactor)
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.8,
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
                                        'Day',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        _updateSelectedBottom('Select Day');
                                        _sendTodayToApi();
                                      }),
                                  ButtonBarEntry(
                                      child: Text(
                                        'Week',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        _updateSelectedBottom('Select Week');
                                        _sendThisWeekToApi();
                                      }),
                                  ButtonBarEntry(
                                      child: Text(
                                        'Month',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        _updateSelectedBottom('Select Month');
                                        _SendThisMonthToApi();
                                      }),
                                  ButtonBarEntry(
                                      child: Text('Year',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        _updateSelectedBottom('Select Year');
                                        _sendThisYearToApi();
                                      })
                                ],
                              ),
                              SizedBox(height: 20 * textScaleFactor),
                              InkWell(
                                onTap: () {
                                  if (selectedPeriod == 'Select Day') {
                                    _selectDay(context);
                                  } else if (selectedPeriod == 'Select Week') {
                                    _selectWeek(context);
                                  } else if (selectedPeriod == 'Select Month') {
                                    _selectMonth(context);
                                  } else if (selectedPeriod == 'Select Year') {
                                    _selectYear(context);
                                  }
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
                                      selectedPeriod,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
