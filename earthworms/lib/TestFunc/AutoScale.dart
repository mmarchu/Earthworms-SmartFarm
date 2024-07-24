import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date Range Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarRangePicker(),
    );
  }
}

class CalendarRangePicker extends StatefulWidget {
  @override
  _CalendarRangePickerState createState() => _CalendarRangePickerState();
}

class _CalendarRangePickerState extends State<CalendarRangePicker> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Range Picker'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.now(),
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;

                if (_rangeStart == null ||
                    (_rangeStart != null && _rangeEnd != null)) {
                  _rangeStart = selectedDay;
                  _rangeEnd = null;
                } else if (_rangeStart != null && _rangeEnd == null) {
                  if (selectedDay.isBefore(_rangeStart!) ||
                      selectedDay
                          .isAfter(_rangeStart!.add(Duration(days: 6)))) {
                    _rangeStart = selectedDay;
                  } else {
                    _rangeEnd = selectedDay;
                  }
                }
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {},
            calendarStyle: CalendarStyle(
              rangeHighlightColor: Colors.blue.withOpacity(0.5),
              withinRangeTextStyle: TextStyle(color: Colors.white),
              withinRangeDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent,
              ),
            ),
          ),
          if (_rangeStart != null && _rangeEnd != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Selected range: ${_rangeStart?.toLocal()} - ${_rangeEnd?.toLocal()}'),
            ),
        ],
      ),
    );
  }
}
