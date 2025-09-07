import 'dart:math';

import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/NumberSelector.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  DatePicker({
    super.key,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    this.nullable = true,
  }) : initialDate = DateUtils.dateOnly(initialDate ?? DateTime.now()),
       firstDate = DateUtils.dateOnly(firstDate ?? DateTime(1900)),
       lastDate = DateUtils.dateOnly(lastDate ?? DateTime(2100)) {
    assert(
      (this.lastDate).isAfter(this.firstDate),
      'lastDate $this.lastDate must be on or after firstDate $this.firstDate.',
    );
    assert(
      this.initialDate.isAfter(this.firstDate),
      'initialDate $this.initialDate must be on or after firstDate $this.firstDate.',
    );
    assert(
      this.initialDate.isBefore(this.lastDate),
      'initialDate $this.initialDate must be on or before lastDate $this.lastDate.',
    );
  }

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool nullable;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime _selectedDate = widget.initialDate;
  int _monthlyDays = 0;
  int _firstDayOffset = 0;

  final TextEditingController _ctrlDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    _changeDate(widget.initialDate);
    _formatDateField(_selectedDate);
  }

  void _handleConfirm() {
    if (_selectedDate == widget.initialDate) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, Success(_selectedDate));
    }
  }

  DateTime _parseDateField() {
    return parseUnknownDate(_ctrlDate.text) ?? _selectedDate;
  }

  void _formatDateField(DateTime dt) {
    String ds = formatUnknownDate(dt);
    setState(() => _ctrlDate.text = ds);
  }

  void _changeDate(DateTime date) {
    if (date.isBefore(widget.firstDate)) date = widget.firstDate;
    if (date.isAfter(widget.lastDate)) date = widget.lastDate;

    setState(() {
      _selectedDate = date;
      _monthlyDays = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
      _firstDayOffset = DateTime(_selectedDate.year, _selectedDate.month).weekday - 1;
    });
  }

  void _handleYearJump(int jump) {
    if (jump == 0) return;
    int maxDays = DateTime(_selectedDate.year + jump, _selectedDate.month + 1, 0).day;
    DateTime newDate = DateTime(_selectedDate.year + jump, _selectedDate.month, min(_selectedDate.day, maxDays));
    _changeDate(newDate);
    _formatDateField(_selectedDate);
  }

  void _handleMonthJump(int jump) {
    if (jump == 0) return;
    int maxDays = DateTime(_selectedDate.year, _selectedDate.month + jump + 1, 0).day;
    DateTime newDate = DateTime(_selectedDate.year, _selectedDate.month + jump, min(_selectedDate.day, maxDays));
    _changeDate(newDate);
    _formatDateField(_selectedDate);
  }

  void _handleDayJump(int jump) {
    if (jump == 0) return;
    DateTime newDate = _selectedDate.add(Duration(days: jump));
    _changeDate(newDate);
    _formatDateField(_selectedDate);
  }

  void _handleDayPick(int day) {
    DateTime newDate = DateTime(_selectedDate.year, _selectedDate.month, day);
    setState(() => _ctrlDate.text = formatIsoDate(_selectedDate) ?? '');
    _changeDate(newDate);
    _formatDateField(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final Widget selector = Container(
      alignment: AlignmentDirectional.center,
      child: Flex(
        direction: MediaQuery.sizeOf(context).width > 300 ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NumberSelector(
            child: Text(
              AppLocalizations.of(context)!.dateYear,
              style: TextStyle(color: Colors.amber),
              textAlign: TextAlign.center,
            ),
            onChange: _handleYearJump,
          ),
          NumberSelector(
            child: Text(
              AppLocalizations.of(context)!.dateMonth,
              style: TextStyle(color: Colors.amber),
              textAlign: TextAlign.center,
            ),
            onChange: _handleMonthJump,
          ),
          NumberSelector(
            child: Text(
              AppLocalizations.of(context)!.dateDay,
              style: TextStyle(color: Colors.amber),
              textAlign: TextAlign.center,
            ),
            onChange: _handleDayJump,
          ),
        ],
      ),
    );

    Widget form = SizedBox(
      width: 180,
      child: Focus(
        child: TextFormField(
          controller: _ctrlDate,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          maxLines: 1,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(0, 10, 2, 0),
          ),
        ),
        onFocusChange: (hasFocus) {
          if (!hasFocus) _changeDate(_parseDateField());
        },
      ),
    );

    List<String> weekdays = getWeekdaysShort(context);

    final Widget calendar = Container(
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        childAspectRatio: 1.5,
        children:
            List.generate(7, (index) {
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
          onPressed: () => Navigator.pop(context),
          text: AppLocalizations.of(context)!.actionCancel,
        ),
        if (widget.nullable) Spacer(),
        if (widget.nullable)
          AppButton(
            onPressed: () => Navigator.pop(context, Success(null)),
            text: AppLocalizations.of(context)!.actionRemove,
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
        Text(_selectedDate.fmtDate(context), style: TextStyle(fontWeight: FontWeight.bold)),
        form,
        selector,
        calendar,
        actions,
      ],
    );
  }
}
