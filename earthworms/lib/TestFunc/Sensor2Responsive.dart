import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class TimeSE1 extends StatefulWidget {
  const TimeSE1({super.key});

  @override
  State<TimeSE1> createState() => _TimeSE1State();
}

class _TimeSE1State extends State<TimeSE1> {

  List<FlSpot> _dataPoints = [];
  late String _apiUrl;

  void _fetchData(String apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        _dataPoints = data
            .map((point) => FlSpot(point['x'], point['y'].toDouble()))
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          screenWidth < screenHeight ? screenWidth : screenHeight;
      // ignore: unused_local_variable
      final textScaleFactor = smallestDimension / 400;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _dataPoints,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                    ),
                    // showTitles: true,
                    // getTitles: (value) {
                    //   return value.toString();
                    // },
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true
                    ),
                    // showTitles: true,
                    // getTitles: (value) {
                    //   return value.toString();
                    // },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _apiUrl = 'http://localhost:4000/api/auth/day';
                  });
                  _fetchData(_apiUrl);
                },
                child: Text('Daily'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _apiUrl = 'http://localhost:4000/api/auth/week';
                  });
                  _fetchData(_apiUrl);
                },
                child: Text('Weekly'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _apiUrl = 'http://localhost:4000/api/auth/month';
                  });
                  _fetchData(_apiUrl);
                },
                child: Text('Monthly'),
              ),
            ],
          ),
        ],
      ),
    );
    });
  }
}
