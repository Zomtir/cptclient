import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/design/AppInputDecoration.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';
import 'package:cptclient/material/dialogs/TimePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeEdit extends StatefulWidget {
  final DateTimeController controller;
  final void Function(DateTime)? onUpdate;
  final bool nullable;
  final bool dateOnly;

  DateTimeEdit({super.key, required this.controller, this.onUpdate, this.nullable = false, this.dateOnly = false});

  @override
  State<DateTimeEdit> createState() => _DateTimeEditState();
}

class _DateTimeEditState extends State<DateTimeEdit> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat("yyyy-MM-dd").format(widget.controller.getDate());
    timeController.text = DateFormat("HH:mm").format(widget.controller.getDate());
  }

  void _handleDateChange(BuildContext context) async {
    DateTime? date = await showAppDatePicker(context: context, initialDate: widget.controller.getDate());

    if (date == null) {
      return;
    }

    setState(() {
      widget.controller.setDate(date);
      dateController.text = DateFormat("yyyy-MM-dd").format(widget.controller.getDate());
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
      timeController.text = DateFormat("HH:mm").format(widget.controller.getDate());
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
              widget.controller.setDateTime((enabled != null && enabled) ? DateTime.now() : null);
            }),
          ),
        if (!widget.controller.isNull())
          SizedBox(
            width: 120,
            height: 40,
            child: TextField(
              controller: dateController,
              maxLines: 1,
              onChanged: (String text) {
                setState(() {
                  widget.controller.tryParseDate(text);
                });
              },
              decoration: AppInputDecoration(),
            ),
          ),
        if (!widget.controller.isNull())
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () => _handleDateChange(context),
          ),
        if (!widget.dateOnly && !widget.controller.isNull())
          SizedBox(
            width: 120,
            height: 40,
            child: TextField(
              controller: timeController,
              maxLines: 1,
              onChanged: (String text) {
                setState(() {
                  widget.controller.tryParseTime(text);
                });
              },
              decoration: AppInputDecoration(),
            ),
          ),
        if (!widget.dateOnly && !widget.controller.isNull())
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () => _handleTimeChange(context),
          ),
      ],
    );
  }
}
