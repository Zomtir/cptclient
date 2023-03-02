import 'package:flutter/src/material/time.dart';

extension DateTimeExtension on DateTime {
  DateTime apply(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}