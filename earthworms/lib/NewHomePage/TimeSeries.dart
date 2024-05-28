import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';

class TimeSeries extends StatefulWidget {
  const TimeSeries({super.key});

  @override
  State<TimeSeries> createState() => _TimeSeriesState();
}

class _TimeSeriesState extends State<TimeSeries> {
  // List<SalesData> _chartData;
  // TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    // _chartData = getChartData();
    // _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
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
          backgroundColor: const Color.fromRGBO(250, 246, 229, 1),
          body: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //Humidity
                              SizedBox(
                                width: 350 * textScaleFactor,
                                height: 200 * textScaleFactor,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(42, 62, 54, 190),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SfCartesianChart(
                                    legend: Legend(isVisible: true),
                                    //tooltipBehavior: ,
                                  ),
                                  ),
                              )
                            ],
                          )),
                      ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
    
  }
}
List<SalesData> getChartData() {
  final List<SalesData> chartData = [
    SalesData(2017, 25),
    SalesData(2018, 12),
    SalesData(2019, 24),
    SalesData(2020, 18),
    SalesData(2021, 30)
  ];
  return chartData;
}


class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}