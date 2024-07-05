import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TemtimeSeriesPage extends StatefulWidget {
  const TemtimeSeriesPage({super.key});

  @override
  State<TemtimeSeriesPage> createState() => _TemtimeSeriesPageState();
}

class _TemtimeSeriesPageState extends State<TemtimeSeriesPage> {
  String _selectedPeriod = 'daily';

  void _onPeriodChanged(String? value) {
    setState(() {
      _selectedPeriod = value!;
    });
    print(_selectedPeriod);
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
                                  onTap: () => _onPeriodChanged,
                                ),
                                ButtonBarEntry(
                                    child: Text(
                                      'Week',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () => _onPeriodChanged),
                                ButtonBarEntry(
                                    child: Text(
                                      'Month',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () => _onPeriodChanged)
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
