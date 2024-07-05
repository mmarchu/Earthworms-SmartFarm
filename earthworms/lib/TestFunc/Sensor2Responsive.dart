import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TimeSeriesPage extends StatefulWidget {
  @override
  _TimeSeriesPageState createState() => _TimeSeriesPageState();
}

class _TimeSeriesPageState extends State<TimeSeriesPage> {
  String _selectedPeriod = 'daily';
  DateTime _selectedDate = DateTime.now();
  DateTimeRange? _selectedDateRange;
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String url =
        'http://localhost:4000/data?period=$_selectedPeriod&date=$_selectedDate';
    if (_selectedPeriod == 'weekly' && _selectedDateRange != null) {
      url =
          'http://localhost:4000/data?period=$_selectedPeriod&start=${_selectedDateRange!.start}&end=${_selectedDateRange!.end}';
    } else if (_selectedPeriod == 'monthly') {
      url =
          'http://localhost:4000/data?period=$_selectedPeriod&date=${_selectedDate.year}-${_selectedDate.month}';
    }

    final response = await http.get(Uri.parse(url));

    // if (response.statusCode == 200) {
    //   setState(() {
    //     _data = json.decode(response.body);
    //   });
    // } else {
    //   throw Exception('Failed to load data');
    // }
  }

  void _onPeriodChanged(String? value) {
    setState(() {
      _selectedPeriod = value!;
    });
    _fetchData();
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedDateRange = null;
    });
    _fetchData();
  }

  void _onDateRangeChanged(DateTimeRange dateRange) {
    setState(() {
      _selectedDateRange = dateRange;
      _selectedDate = dateRange.start;
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstDate = DateTime.now().subtract(Duration(days: 30));
    DateTime lastDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Time Series App'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedPeriod,
            onChanged: _onPeriodChanged,
            items: [
              DropdownMenuItem(value: 'daily', child: Text('Daily')),
              DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
              DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (_selectedPeriod == 'daily') {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );
                if (pickedDate != null) {
                  _onDateChanged(pickedDate);
                }
              } else if (_selectedPeriod == 'weekly') {
                DateTime endOfWeek = _selectedDate.add(Duration(
                    days: DateTime.daysPerWeek - _selectedDate.weekday));
                if (endOfWeek.isAfter(lastDate)) {
                  endOfWeek = lastDate;
                }
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate:
                      endOfWeek.subtract(Duration(days: 6)), // Limit to 7 days
                  selectableDayPredicate: (DateTime day) {
                    // Allow selection only if it's within 7 days
                    int daysDifference = day.difference(_selectedDate).inDays;
                    return daysDifference >= 0 && daysDifference <= 6;
                  },
                );
                if (pickedDate != null) {
                  _onDateChanged(pickedDate);
                }
              } else if (_selectedPeriod == 'monthly') {
                DateTime? pickedDate = await showMonthPicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );
                if (pickedDate != null) {
                  _onDateChanged(pickedDate);
                }
              }
            },
            child: Text('Select Date'),
          ),
          Expanded(
            child: _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: _data.map((item) {
          return BarChartGroupData(
            x: item['x'],
            barRods: [
              BarChartRodData(
                toY: item['y'].toDouble(),
                color: Colors.blue,
                width: 15,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
