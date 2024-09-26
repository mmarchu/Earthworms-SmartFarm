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
  // final BehaviorSubject<Map<String, List<String>>> _dataController =
  //     BehaviorSubject<Map<String, List<String>>>();
  String dateSelectDisplay = '';
  String dateSelectApi = '';
  String RatLog = '0';
  String ToadLog = '0';
  String LizardLog = '0';
  Map<String, double> dataMap = {};
  final ColorList = <Color>[
    Color.fromRGBO(121, 142, 164, 1),
    Color.fromRGBO(252, 126, 52, 1),
    Color.fromRGBO(2, 117, 144, 1)
  ];
  List<String> idList = [];
  List<String> typeList = [];
  List<String> is_imageList = [];
  List<String> dateList = [];
  List<String> timeList = [];

  @override
  void initState() {
    super.initState();
    //_SendThisMonthToApi();
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
        "date": DateFormat('yyyy-MM-dd').format(selectedDate),
      };
      final displayDate = DateFormat.MMMM('en_US').format(selectedDate);
      final monthSelected = DateFormat('yyyy-MM-dd').format(selectedDate);
      print(displayDate);
      _updateMonthApi(monthSelected);
      _updateDateData(displayDate);
      _sendDataToApiPieChart(json);
    }
  }

// Send this month to Api
  void _SendThisMonthToApi() {
    final today = DateTime.now();
    final json = {
      "date": DateFormat('yyyy-MM-dd').format(today),
    };
    final displayDate = DateFormat.MMMM('en_US').format(today);
    final monthSelected = DateFormat('yyyy-MM-dd').format(today);
    print(displayDate);
    _updateMonthApi(monthSelected);
    _updateDateData(displayDate);
    _sendDataToApiPieChart(json);
  }

// update display Date
  void _updateDateData(String newDate) {
    setState(() {
      dateSelectDisplay = newDate;
    });
  }

// update month API
  void _updateMonthApi(String newDate) {
    setState(() {
      dateSelectApi = newDate;
    });
    print("Month: $dateSelectApi");
  }

// send month to get data for PieChart
  Future<void> _sendDataToApiPieChart(final json) async {
    String? token = await loadData('Token');
    var url;

    if (Platform.isAndroid) {
      url = ApiUrl.ANDGetLogEnemiesPieChart;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSGetLogEnemiesPieChart;
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

// send month to get data for ListView
  Future<void> _sendDataToApiListView(final enemy, final month) async {
    String? token = await loadData('Token');
    var url;

    if (Platform.isAndroid) {
      url = ApiUrl.ANDGetLogEnemieListView;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSGetLogEnemiesListview;
    }
    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charest=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'type_enemies': enemy, 'date': month}));

      if (response.statusCode == 200) {
        final List<dynamic> parsedData = jsonDecode(response.body);
        List<String> id = [];
        List<String> type = [];
        List<String> is_image = [];
        List<String> createdAt = [];
        List<String> date = [];
        List<String> time = [];

        for (var item in parsedData) {
          id.add(item['id'].toString());
          type.add(item['type'].toString());
          is_image.add(item['is_image'].toString());
          createdAt.add(item['createdAt'].toString());
          date.add(item['date'].toString());
          time.add(item['time'].toString());
        }
        // _dataController.add({
        //   'id': id,
        //   'type': type,
        //   'is_image': is_image,
        //   'createdAt': createdAt,
        //   'date': date,
        //   'time': time
        // });
        setState(() {
          idList = id;
          typeList = type;
          is_imageList = is_image;
          dateList = date;
          timeList = time;
        });
        print(id);
        print("IdList: $idList");
      }
    } catch (e) {
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
                                    dateSelectDisplay,
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
                              dataMap.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: 2 * textScaleFactor,
                                          left: 2 * textScaleFactor),
                                      child: PieChart(
                                        dataMap: dataMap,
                                        animationDuration:
                                            Duration(milliseconds: 2000),
                                        chartLegendSpacing: 32,
                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        colorList: ColorList,
                                        initialAngleInDegree: 0,
                                        chartType: ChartType.disc,
                                        ringStrokeWidth: 32,
                                        legendOptions: LegendOptions(
                                          showLegendsInRow: false,
                                          legendPosition: LegendPosition.right,
                                          showLegends: true,
                                          legendShape: BoxShape.rectangle,
                                          legendTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        chartValuesOptions: ChartValuesOptions(
                                            showChartValueBackground: true,
                                            showChartValues: true,
                                            showChartValuesInPercentage: false,
                                            showChartValuesOutside: false,
                                            decimalPlaces: 0,
                                            chartValueStyle: TextStyle(
                                                fontSize: 16 * textScaleFactor,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          top: 135 * textScaleFactor),
                                      child: Text(
                                        'No data available',
                                        style: TextStyle(
                                            fontSize: 25 * textScaleFactor),
                                      ),
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
                                          _sendDataToApiListView(
                                              "Rat", "2024-09-01");
                                          print("Rat");
                                        }),
                                    ButtonBarEntry(
                                        child: Text(
                                          'Toad',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          _sendDataToApiListView(
                                              "Toad", dateSelectApi);
                                          print("Toad");
                                        }),
                                    ButtonBarEntry(
                                        child: Text(
                                          'Lizard',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          _sendDataToApiListView(
                                              "Lizard", dateSelectApi);
                                          print("Lizard");
                                        })
                                  ],
                                )
                              ],
                            ),
                          ))),
                  Positioned(
                      top: ScreenHeight * 0.6,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(27),
                          topRight: Radius.circular(27),
                        ),
                        child: Container(
                          color: Color.fromRGBO(250, 246, 229, 1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15 * textScaleFactor,
                                    bottom: 15 * textScaleFactor),
                                child: SizedBox(
                                  width: ScreenWidth - 120,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                            fontSize: 15 * textScaleFactor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 13 * textScaleFactor),
                                        child: Text(
                                          'Time',
                                          style: TextStyle(
                                              fontSize: 15 * textScaleFactor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        'Image',
                                        style: TextStyle(
                                            fontSize: 15 * textScaleFactor,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: idList.length == 0
                                      ? Center(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10 * textScaleFactor),
                                                child: Text(
                                                  'No data available',
                                                  style: TextStyle(
                                                      fontSize:
                                                          20 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: idList.length,
                                          itemBuilder: (context, Index) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          5 * textScaleFactor),
                                                  child: SizedBox(
                                                    width: ScreenWidth - 40,
                                                    height:
                                                        50 * textScaleFactor,
                                                    child: DecoratedBox(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    232,
                                                                    225,
                                                                    198,
                                                                    1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: 110 *
                                                                  textScaleFactor,
                                                              height: 70 *
                                                                  textScaleFactor,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 10 *
                                                                            textScaleFactor),
                                                                    child:
                                                                        AutoSizeText(
                                                                      dateList[
                                                                          Index],
                                                                      style: TextStyle(
                                                                          fontSize: 13 *
                                                                              textScaleFactor,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      maxLines:
                                                                          1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 110 *
                                                                  textScaleFactor,
                                                              height: 70 *
                                                                  textScaleFactor,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 10 *
                                                                            textScaleFactor),
                                                                    child:
                                                                        AutoSizeText(
                                                                      timeList[
                                                                          Index],
                                                                      style: TextStyle(
                                                                          fontSize: 13 *
                                                                              textScaleFactor,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      maxLines:
                                                                          1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 110 *
                                                                  textScaleFactor,
                                                              height: 70 *
                                                                  textScaleFactor,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        right: 15 *
                                                                            textScaleFactor),
                                                                    child: IconButton(
                                                                        onPressed: () {},
                                                                        icon: Icon(
                                                                          Icons
                                                                              .collections,
                                                                          size: 25 *
                                                                              textScaleFactor,
                                                                        )),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                )
                                              ],
                                            );
                                          }))
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
