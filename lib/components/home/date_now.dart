import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateNow extends StatefulWidget {
  const DateNow({super.key});

  @override
  State<DateNow> createState() => _DateNowState();
}

class _DateNowState extends State<DateNow> {
  DateTime _selectedDate = DateTime.now();
  void _onDateChange(DateTime date) {
    this.setState(() {
      this._selectedDate = date;
    });
  }
  @override
  Widget build(BuildContext context) {
    return DatePicker(
      DateTime.now(),
      initialSelectedDate: this._selectedDate,
      selectionColor: Colors.lightBlue,
      onDateChange: this._onDateChange,
    );
  }
}