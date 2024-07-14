import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DateSelector extends StatefulWidget {
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _selectDay(context),
            child: Text('Day'),
          ),
          ElevatedButton(
            onPressed: () => _selectWeek(context),
            child: Text('Week'),
          ),
          ElevatedButton(
            onPressed: () => _selectMonth(context),
            child: Text('Month'),
          ),
        ],
      ),
    );
  }

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
      _sendToApi(json);
    }
  }

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
      _sendToApi(json);
    }
  }

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
      _sendToApi(json);
    }
  }

  void _sendToApi(Map<String, dynamic> json) {
    // ส่ง json ไปยัง API ที่นี่
    print(json);
  }
}
