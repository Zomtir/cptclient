import 'package:cptclient/static/extensions.dart';
import "package:flutter/material.dart";

class DateTimeController<T> {
  DateTime? _dateTime;

  DateTimeController({DateTime? dateTime}) : _dateTime = dateTime;

  bool isNull() {
    return _dateTime == null;
  }

  void setDateTime(DateTime? dateTime) {
    _dateTime = dateTime;
  }

  DateTime? getDateTime() {
    return _dateTime;
  }

  void setDate(DateTime date) {
    _dateTime = _dateTime?.applyDate(date);
  }

  DateTime getDate() {
    return _dateTime ?? DateTime.now();
  }

  void setTime(TimeOfDay time) {
    _dateTime = _dateTime?.applyTime(time);
  }

  TimeOfDay getTime() {
    return TimeOfDay.fromDateTime(_dateTime ?? DateTime.now());
  }
}
