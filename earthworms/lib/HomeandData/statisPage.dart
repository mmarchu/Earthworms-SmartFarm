import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:earthworms/MainFunction/RegisterPage.dart';

class statisPage extends StatefulWidget {
  statisPage({super.key});

  @override
  State<statisPage> createState() => _statisPageState();
}

class _statisPageState extends State<statisPage> {
  String SelectButton = " ";
  final List<double> data = [
    10,
    20,
    15,
    25,
    30,
    18,
    12,
    28,
    22,
    17,
    29,
    14,
    26,
    19,
    23,
    16,
    27,
    21,
    13,
    24,
    11,
    30,
    15,
    28,
    20,
    12,
    26,
    18,
    14,
    22
  ];

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
            body: SafeArea(
              child: Container(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 35,
                                color: Colors.grey[800],
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    //Text Header
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 35 * textScaleFactor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Summary",
                            style: TextStyle(
                              fontSize: 40 * textScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 35 * textScaleFactor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Report",
                              style: TextStyle(
                                fontSize: 40 * textScaleFactor,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    //Category
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30 * textScaleFactor,
                          vertical: 10 * textScaleFactor),
                      child: Column(
                        children: [
                          ToggleSwitch(
                            customWidths: [105.0, 120.0, 105.0],
                            minHeight: 50,
                            initialLabelIndex: 5,
                            cornerRadius: 30.0,
                            animate: true,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Color.fromRGBO(179, 176, 163, 1),
                            inactiveFgColor: Colors.black,
                            totalSwitches: 3,
                            labels: ['Humidity', 'Temperature', 'Light'],
                            activeBgColors: [
                              [Colors.blue],
                              [Colors.pink],
                              [Color.fromRGBO(213, 213, 165, 10)]
                            ],
                            onToggle: (index) {
                              //SelectB = index;
                              //print(index);
                              if (index == 0) {
                                SelectButton = "0";
                                print("Button = $SelectButton");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              } else if (index == 1) {
                                SelectButton = "1";
                                print("Button = $SelectButton");
                              } else {
                                SelectButton = "2";
                                print("Button = $SelectButton");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // BarChart(
                    //   BarChartData(
                    //     alignment: BarChartAlignment.spaceAround,
                    //     maxY: 100,
                    //     titlesData: FlTitlesData(
                    //       leftTitles: SideTitles(
                    //         showTitles: true,
                    //         getTextStyles: (value) => const TextStyle(
                    //           color: Color(0xff7589a2),
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 14,
                    //         ),)
                    //     )
                    //   )
                    // )
                  ],
                ),
              )),
            )),
      );
    });
  }
}
