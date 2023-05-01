import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DateTimeController.dart';
import 'design/AppSelectDecoration.dart';
import 'dialogs/DatePicker.dart';
import 'dialogs/TimePicker.dart';

class DateTimeEdit extends StatefulWidget {
  final DateTimeController controller;
  final void Function(DateTime)? onUpdate;
  final bool nullable;
  final bool dateOnly;

  const DateTimeEdit({super.key, required this.controller, this.onUpdate, this.nullable = false, this.dateOnly = false});

  @override
  State<DateTimeEdit> createState() => _DateTimeEditState();
}

class _DateTimeEditState extends State<DateTimeEdit> {
  @override
  void initState() {
    super.initState();
  }

  void _handleDateChange(BuildContext context) async {
    DateTime? date = await showAppDatePicker(context: context, initialDate: widget.controller.getDate());

    if (date == null) {
      return;
    }

    setState(() {
      widget.controller.setDate(date);
    });

    widget.onUpdate?.call(widget.controller.getDateTime()!);
  }

  void _handleTimeChange(BuildContext context) async {
    TimeOfDay? time = await showAppTimePicker(context: context, initialTime: widget.controller.getTime());

    if (time == null) {
      return;
    }

    setState(() {
      widget.controller.setTime(time);
    });

    widget.onUpdate?.call(widget.controller.getDateTime()!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.nullable == true)
          Checkbox(
            value: !widget.controller.isNull(),
            onChanged: (bool? enabled) => setState(() {
              widget.controller.setDateTime( (enabled != null && enabled) ? DateTime.now() : null);
            }),
          ),
        if (!widget.controller.isNull()) InkWell(
          child: Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(4.0),
            decoration: const AppSelectDecoration(),
            child: Text(DateFormat("yyyy-MM-dd").format(widget.controller.getDate())),
          ),
          onTap: () => _handleDateChange(context),
        ),
        if (!widget.dateOnly && !widget.controller.isNull())
          InkWell(
            child: Container(
              margin: const EdgeInsets.all(2.0),
              padding: const EdgeInsets.all(4.0),
              decoration: const AppSelectDecoration(),
              child: Text(DateFormat("HH:mm").format(widget.controller.getDate())),
            ),
            onTap: () => _handleTimeChange(context),
          ),
      ],
    );
  }
}
