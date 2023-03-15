import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

import '../AppDialog.dart';

Future<TimeOfDay?> showAppTimePicker({
  required BuildContext context,
  DateTime? initialDateTime,
}) async {
  initialDateTime = initialDateTime ?? DateTime.now();

  Widget picker = TimePicker(
    initialDateTime: initialDateTime,
  );

  return showDialog<TimeOfDay>(
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

class TimePicker extends StatefulWidget {
  TimePicker({
    super.key,
    required DateTime initialDateTime,
  }) : initialTime = TimeOfDay.fromDateTime(initialDateTime);

  final TimeOfDay initialTime;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late TimeOfDay _selectedTime;

  TextEditingController _ctrlHour = TextEditingController();
  TextEditingController _ctrlMinute = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectTime(widget.initialTime);
  }

  void _handleOk() {
    if (_selectedTime == widget.initialTime)
      _handleCancel();
    else
      Navigator.pop(context, _selectedTime);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _parseTimeFields() {
    int hour = int.tryParse(_ctrlHour.text) ?? _selectedTime.hour;
    int minute = int.tryParse(_ctrlMinute.text) ?? _selectedTime.minute;
    _selectTime(TimeOfDay(hour: hour, minute: minute));
  }

  void _selectTime(TimeOfDay time) {
    _selectedTime = TimeOfDay(hour: time.hour % TimeOfDay.hoursPerDay, minute: time.minute % TimeOfDay.minutesPerHour);

    setState(() {
      _ctrlHour.text = _selectedTime.hour.toString();
      _ctrlMinute.text = _selectedTime.minute.toString();
    });
  }

  void _handleHourJump(int jump) {
    _parseTimeFields();
    if (jump == 0) return;
    TimeOfDay newTime = TimeOfDay(hour: _selectedTime.hour + jump, minute: _selectedTime.minute);
    _selectTime(newTime);
  }

  void _handleMinuteJump(int jump) {
    _parseTimeFields();
    if (jump == 0) return;
    TimeOfDay newTime = TimeOfDay(hour: _selectedTime.hour, minute: _selectedTime.minute + jump % TimeOfDay.minutesPerHour);
    _selectTime(newTime);
  }

  void _handleHourPick(int hour) {
    TimeOfDay newTime = TimeOfDay(hour: hour, minute: _selectedTime.minute);
    _selectTime(newTime);
  }

  void _handleMinutePick(int minute) {
    TimeOfDay newTime = TimeOfDay(hour: _selectedTime.hour, minute: minute);
    _selectTime(newTime);
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
          IconButton(onPressed: () => _handleHourJump(-1), icon: Icon(Icons.chevron_left)),
          SizedBox(
            width: 60,
            child: Focus(
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                controller: _ctrlHour,
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus) _parseTimeFields();
              },
            ),
          ),
          IconButton(onPressed: () => _handleHourJump(1), icon: Icon(Icons.chevron_right)),
          SizedBox(width: 5),
          IconButton(onPressed: () => _handleMinuteJump(-1), icon: Icon(Icons.chevron_left)),
          SizedBox(
            width: 50,
            child: Focus(
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                controller: _ctrlMinute,
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus) _parseTimeFields();
              },
            ),
          ),
          IconButton(onPressed: () => _handleMinuteJump(1), icon: Icon(Icons.chevron_right)),
        ],
      ),
    );

    final Widget clock = Container(
      width: 350,
      height: 350,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(350, 350),
            painter: ClockPainer(_selectedTime.hour, _selectedTime.minute),
          ),
          for (var i = 0; i < 60; i += 5)
            buildWatchNumbers(
              150 * sin(i / 60 * 2 * pi),
              150 * -cos(i / 60 * 2 * pi),
              i.toString(),
              Colors.blue.withOpacity(0.5),
              () => _handleMinutePick(i),
            ),
          for (var i = 0; i < 12; i++)
            buildWatchNumbers(
              100 * sin(i / 12 * 2 * pi),
              100 * -cos(i / 12 * 2 * pi),
              i.toString(),
              Colors.red.withOpacity(0.5),
              () => _handleHourPick(i),
            ),
          for (var i = 12; i < 24; i++)
            buildWatchNumbers(
              65 * sin(i / 12 * 2 * pi),
              65 * -cos(i / 12 * 2 * pi),
              i.toString(),
              Colors.red.withOpacity(0.5),
              () => _handleHourPick(i),
            ),
        ],
      ),
    );

    return Column(
      children: [
        actions,
        form,
        clock,
      ],
    );
  }

  Positioned buildWatchNumbers(double left, double top, String label, Color color, VoidCallback onPressed) {
    return Positioned(
      left: 162 + left,
      top: 162 + top,
      width: 26,
      height: 26,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          child: Center(
            child: Text(label),
          ),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class ClockPainer extends CustomPainter {
  final double hx, hy, mx, my;

  ClockPainer(int hour, int minute)
      : hx = sin(hour / 12 * 2 * pi) * ((hour > 11) ? 45 : 80),
        hy = -cos(hour / 12 * 2 * pi) * ((hour > 11) ? 45 : 80),
        mx = sin(minute / 60 * 2 * pi) * 115,
        my = -cos(minute / 60 * 2 * pi) * 115;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(175, 175), 125, paint);

    drawPointer(canvas, Offset(hx, hy), Colors.red.withOpacity(0.5), 10);
    drawPointer(canvas, Offset(mx, my), Colors.blue.withOpacity(0.5), 6);
  }

  void drawPointer(Canvas canvas, Offset offset, Color color, double width) {
    final points = [
      Offset(175, 175),
      Offset(175, 175) + offset,
    ];

    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(PointMode.polygon, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }

}
