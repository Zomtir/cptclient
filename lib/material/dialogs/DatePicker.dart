import 'dart:math';

import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/NumberSelector.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate = DateUtils.dateOnly(initialDate ?? DateTime.now());

  Widget picker = DatePicker(
    initialDate: initialDate,
    firstDate: firstDate ?? DateTime(1900),
    lastDate: lastDate ?? DateTime(2100),
  );

  assert(
    (lastDate ?? DateTime(2100)).isAfter(firstDate ?? DateTime(1900)),
    'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
    initialDate.isAfter(firstDate ?? DateTime(1900)),
    'initialDate $initialDate must be on or after firstDate $firstDate.',
  );
  assert(
    initialDate.isBefore(lastDate ?? DateTime(2100)),
    'initialDate $initialDate must be on or before lastDate $lastDate.',
  );

  return showDialog<DateTime>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppDialog(
        child: picker,
        maxWidth: 470,
      );
    },
  );
}

class DatePicker extends StatefulWidget {
  DatePicker({
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
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime _selectedDate = widget.initialDate;
  int _monthlyDays = 0;
  int _firstDayOffset = 0;

  final TextEditingController _ctrlYear = TextEditingController();
  final TextEditingController _ctrlMonth = TextEditingController();
  final TextEditingController _ctrlDay = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectDate(widget.initialDate);
  }

  void _handleConfirm() {
    if (_selectedDate == widget.initialDate) {
      _handleCancel();
    } else {
      Navigator.pop(context, _selectedDate);
    }
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
    final Widget form = Container(
      alignment: AlignmentDirectional.center,
      child: Flex(
        direction: MediaQuery.sizeOf(context).width > 400 ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.dateYear,
                style: TextStyle(color: Colors.amber),
                textAlign: TextAlign.center,
              ),
              NumberSelector(controller: _ctrlYear, onChange: _handleYearJump),
            ],
          ),
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.dateMonth,
                style: TextStyle(color: Colors.amber),
                textAlign: TextAlign.center,
              ),
              NumberSelector(controller: _ctrlMonth, onChange: _handleMonthJump),
            ],
          ),
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.dateDay,
                style: TextStyle(color: Colors.amber),
                textAlign: TextAlign.center,
              ),
              NumberSelector(controller: _ctrlDay, onChange: _handleDayJump),
            ],
          ),
        ],
      ),
    );

    List<String> weekdays = getWeekdaysShort(context);

    final Widget calendar = Container(
      width: 350,
      height: 360,
      child: GridView.count(
        crossAxisCount: 7,
        children: List.generate(7, (index) {
              return Center(
                child: Text('${weekdays[index]}', style: TextStyle(color: Colors.amber)),
              );
            }) +
            List.generate(_firstDayOffset, (index) {
              return Center();
            }) +
            List.generate(_monthlyDays, (index) {
              return Center(
                child: TextButton(
                  onPressed: () => _handleDayPick(index + 1),
                  child: Text(
                    '${index + 1}',
                    textScaler: TextScaler.linear(1.2),
                    style: TextStyle(color: (index + 1 == _selectedDate.day) ? Colors.amber : Colors.black),
                  ),
                  style: ButtonStyle(padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
                ),
              );
            }),
      ),
    );

    final Widget actions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AppButton(
          onPressed: _handleCancel,
          text: AppLocalizations.of(context)!.actionCancel,
        ),
        Spacer(),
        AppButton(
          onPressed: _handleConfirm,
          text: AppLocalizations.of(context)!.actionConfirm,
        ),
      ],
    );

    return Column(
      children: [
        form,
        calendar,
        actions,
      ],
    );
  }
}
