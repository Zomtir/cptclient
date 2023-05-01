import "package:flutter/material.dart";

extension DateTimeExtension on DateTime {
  DateTime applyTime(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  DateTime applyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
