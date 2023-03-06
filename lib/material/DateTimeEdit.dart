import 'package:cptclient/static/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DateTimeController.dart';
import 'design/AppSelectDecoration.dart';
import 'dialogs/DatePicker.dart';
import 'dialogs/TimePicker.dart';

class DateTimeEdit extends StatefulWidget {
  final DateTimeController controller;
  final void Function(DateTime)? onUpdate;
  final bool hideTime;

  const DateTimeEdit({super.key, required this.controller, this.onUpdate, this.hideTime = false});

  @override
  State<DateTimeEdit> createState() => _DateTimeEditState();
}

class _DateTimeEditState extends State<DateTimeEdit> {

  @override
  void initState() {
    super.initState();
  }

  void _handleDateChange(BuildContext context) async {
    DateTime? date = await showAppDatePicker(context: context, initialDate: widget.controller.dateTime);

    if (date == null) {
      return;
    }

    setState(() {
      widget.controller.dateTime = date.apply(TimeOfDay.fromDateTime(widget.controller.dateTime));
    });

    widget.onUpdate?.call(widget.controller.dateTime);
  }

  void _handleTimeChange(BuildContext context) async {
    TimeOfDay? time = await showAppTimePicker(context: context, initialDateTime: widget.controller.dateTime);

    if (time == null) {
      return;
    }

    setState(() {
      widget.controller.dateTime = widget.controller.dateTime.apply(time);
    });

    widget.onUpdate?.call(widget.controller.dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(4.0),
            decoration: const AppSelectDecoration(),
            child: Text(DateFormat("yyyy-MM-dd").format(widget.controller.dateTime)),
          ),
          onTap: () => _handleDateChange(context),
        ),
        if (!widget.hideTime) InkWell(
          child: Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(4.0),
            decoration: const AppSelectDecoration(),
            child: Text(DateFormat("HH:mm").format(widget.controller.dateTime)),
          ),
          onTap: () => _handleTimeChange(context),
        ),
      ],
    );
  }
}
