import 'package:cptclient/material/design/AppInputDecoration.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';
import 'package:cptclient/material/dialogs/TimePicker.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeField extends StatefulWidget {
  final DateTimeController controller;
  final void Function(DateTime)? onUpdate;
  final bool nullable;
  final bool showDate;
  final bool showTime;

  DateTimeField({
    super.key,
    required this.controller,
    this.onUpdate,
    this.nullable = false,
    this.showDate = true,
    this.showTime = true,
  });

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat("yyyy-MM-dd").format(widget.controller.getDate());
    timeController.text = DateFormat("HH:mm").format(widget.controller.getDate());
  }

  void _handleDateChange(BuildContext context) async {
    useAppDialog<DateTime>(
      context: context,
      widget: DatePicker(initialDate: widget.controller.getDate()),
      onChanged: (DateTime dt) {
        setState(() {
          widget.controller.setDate(dt);
          dateController.text = DateFormat("yyyy-MM-dd").format(widget.controller.getDate());
        });
        widget.onUpdate?.call(widget.controller.getDateTime()!);
      },
    );
  }

  void _handleTimeChange(BuildContext context) async {
    useAppDialog<TimeOfDay>(
      context: context,
      widget: TimePicker(initialTime: widget.controller.getTime()),
      onChanged: (TimeOfDay tod) {
        setState(() {
          widget.controller.setTime(tod);
          timeController.text = DateFormat("HH:mm").format(widget.controller.getDate());
        });
        widget.onUpdate?.call(widget.controller.getDateTime()!);
      },
    );
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
        Expanded(
          child: Column(
            children: [
              if (widget.showDate && !widget.controller.isNull())
                Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    //
                    children: [
                      Expanded(
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
                      IconButton(
                        icon: Icon(Icons.calendar_month),
                        onPressed: () => _handleDateChange(context),
                      ),
                    ],
                  ),
                ),
              if (widget.showTime && !widget.controller.isNull())
                Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    children: [
                      Expanded(
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
                      IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () => _handleTimeChange(context),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
