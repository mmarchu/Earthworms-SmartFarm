import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:earthworms/HomeandData/Components/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        "date": DateFormat('yyyy-MM').format(selectedDate),
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
      "date": DateFormat('yyyy-MM').format(today),
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

// Api Get Data
  Future<void> _sendDataToApi(final json) async {
    String? token = await loadData('Token');
    var url;

    if (Platform.isAndroid) {
      url = ApiUrl.ANDgetTimeseries;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSgetTimeseries;
    }

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(json));

    if (response.statusCode == 200) {
      // var decodedData = jsonDecode(response.body);
      // print('Decoded Data: $decodedData');
      // setState(() {
      //   _data = decodedData;
      //   period = _period;
      // });
    } else {
      print('${response.statusCode}: ${response.reasonPhrase}');
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
                                  'Enemy Summery',
                                  style: TextStyle(
                                      fontSize: 28 * textScaleFactor,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold),
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
                                      '< $dateSelect >', ///////////////////////////////////
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
