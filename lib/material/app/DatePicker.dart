import 'dart:math';

import 'package:flutter/material.dart';

import 'AppBody.dart';

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  initialDate = DateUtils.dateOnly(initialDate ?? DateTime.now());

  Widget dialog = DatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  assert(
    !lastDate.isBefore(firstDate),
    'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isBefore(firstDate),
    'initialDate $initialDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isAfter(lastDate),
    'initialDate $initialDate must be on or before lastDate $lastDate.',
  );

  return showDialog<DateTime>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppBody(
        children: [dialog],
      );
    },
  );
}

class DatePickerDialog extends StatefulWidget {
  DatePickerDialog({
    super.key,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  })  : initialDate = DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate);

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  late DateTime _selectedDate = widget.initialDate;
  int _monthlyDays = 0;
  int _firstDayOffset = 0;

  TextEditingController _ctrlYear = TextEditingController();
  TextEditingController _ctrlMonth = TextEditingController();
  TextEditingController _ctrlDay = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectDate(widget.initialDate);
  }

  void _handleOk() {
    if (_selectedDate == widget.initialDate)
      _handleCancel();
    else
      Navigator.pop(context, _selectedDate);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _parseDateFields() {
    int year = int.tryParse(_ctrlYear.text) ?? _selectedDate.year;
    int month = int.tryParse(_ctrlMonth.text) ?? _selectedDate.month;
    int day = int.tryParse(_ctrlDay.text) ?? _selectedDate.day;

    _selectDate(DateTime(year, month, day));
  }

  void _selectDate(DateTime date) {
    if (date.isBefore(widget.firstDate)) date = widget.firstDate;
    if (date.isAfter(widget.lastDate)) date = widget.lastDate;

    _selectedDate = date;
    _monthlyDays = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    _firstDayOffset = DateTime(_selectedDate.year, _selectedDate.month).weekday - 1;

    setState(() {
      _ctrlYear.text = _selectedDate.year.toString();
      _ctrlMonth.text = _selectedDate.month.toString();
      _ctrlDay.text = _selectedDate.day.toString();
    });
  }

  void _handleYearJump(int jump) {
    _parseDateFields();
    if (jump == 0) return;
    int maxDays = DateTime(_selectedDate.year + jump, _selectedDate.month + 1, 0).day;
    DateTime newDate = DateTime(_selectedDate.year + jump, _selectedDate.month, min(_selectedDate.day, maxDays));
    _selectDate(newDate);
  }

  void _handleMonthJump(int jump) {
    _parseDateFields();
    if (jump == 0) return;
    int maxDays = DateTime(_selectedDate.year, _selectedDate.month + jump + 1, 0).day;
    DateTime newDate = DateTime(_selectedDate.year, _selectedDate.month + jump, min(_selectedDate.day, maxDays));
    _selectDate(newDate);
  }

  void _handleDayJump(int jump) {
    _parseDateFields();
    if (jump == 0) return;
    DateTime newDate = _selectedDate.add(Duration(days: jump));
    _selectDate(newDate);
  }

  void _handleDayPick(int day) {
    DateTime newDate = DateTime(_selectedDate.year, _selectedDate.month, day);
    _selectDate(newDate);
  }

  @override
  Widget build(BuildContext context) {
    final String cancelText = "Cancel";
    final String confirmText = "Ok";

    final Widget actions = Container(
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: TextButton(
              onPressed: _handleCancel,
              child: Text(cancelText),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 10, top: 10),
            child: TextButton(
              onPressed: _handleOk,
              child: Text(confirmText),
            ),
          ),
        ],
      ),
    );

    final Widget form = Container(
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(onPressed: () => _handleYearJump(-1), icon: Icon(Icons.chevron_left)),
          SizedBox(
            width: 60,
            child: Focus(
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                controller: _ctrlYear,
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus) _parseDateFields();
              },
            ),
          ),
          IconButton(onPressed: () => _handleYearJump(1), icon: Icon(Icons.chevron_right)),
          SizedBox(width: 5),
          IconButton(onPressed: () => _handleMonthJump(-1), icon: Icon(Icons.chevron_left)),
          SizedBox(
            width: 50,
            child: Focus(
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                controller: _ctrlMonth,
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus) _parseDateFields();
              },
            ),
          ),
          IconButton(onPressed: () => _handleMonthJump(1), icon: Icon(Icons.chevron_right)),
          SizedBox(width: 5),
          IconButton(onPressed: () => _handleDayJump(-1), icon: Icon(Icons.chevron_left)),
          SizedBox(
            width: 50,
            child: Focus(
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                controller: _ctrlDay,
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus) _parseDateFields();
              },
            ),
          ),
          IconButton(onPressed: () => _handleDayJump(1), icon: Icon(Icons.chevron_right)),
        ],
      ),
    );

    final Widget calendar = Container(
      width: 350,
      height: 360,
      child: GridView.count(
        crossAxisCount: 7,
        children: _buildCalenderList(context),
      ),
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 500,
        width: 430,
        child: Column(
          children: [
            actions,
            form,
            calendar,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCalenderList(BuildContext context) {
    List<String> weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

    List<Center> lcHeader = List.generate(7, (index) {
      return Center(
        child: Text('${weekdays[index]}', style: TextStyle(color: Colors.amber)),
      );
    });

    List<Center> lcSpacer = List.generate(_firstDayOffset, (index) {
      return Center();
    });

    List<Center> lcDates = List.generate(_monthlyDays, (index) {
      return Center(
        child: TextButton(
          onPressed: () => _handleDayPick(index + 1),
          child: Text(
            '${index + 1}',
            textScaleFactor: 1.6,
            style: TextStyle(color: (index + 1 == _selectedDate.day) ? Colors.amber : Colors.black),
          ),
        ),
      );
    });

    return lcHeader + lcSpacer + lcDates;
  }
}
