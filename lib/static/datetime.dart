import "package:flutter/material.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension DateTimeExtension on DateTime {
  DateTime applyTime(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  DateTime applyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}

List<String> getWeekdaysLong(BuildContext context) {
  return [
    AppLocalizations.of(context)!.weekdayLongMon,
    AppLocalizations.of(context)!.weekdayLongTue,
    AppLocalizations.of(context)!.weekdayLongWed,
    AppLocalizations.of(context)!.weekdayLongThu,
    AppLocalizations.of(context)!.weekdayLongFri,
    AppLocalizations.of(context)!.weekdayLongSat,
    AppLocalizations.of(context)!.weekdayLongSun,
  ];
}

List<String> getWeekdaysShort(BuildContext context) {
  return [
    AppLocalizations.of(context)!.weekdayShortMon,
    AppLocalizations.of(context)!.weekdayShortTue,
    AppLocalizations.of(context)!.weekdayShortWed,
    AppLocalizations.of(context)!.weekdayShortThu,
    AppLocalizations.of(context)!.weekdayShortFri,
    AppLocalizations.of(context)!.weekdayShortSat,
    AppLocalizations.of(context)!.weekdayShortSun,
  ];
}