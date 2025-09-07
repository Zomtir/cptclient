import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/l10n/app_localizations.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime withTime(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  DateTime withDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String fmtDate(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMEd(localeTag).format(this);
  }

  String fmtTime(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.Hm(localeTag).format(this);
  }

  String fmtDateTime(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMEd(localeTag).add_Hm().format(this);

    //return "${fmtDate(context)} ${fmtTime(context)}";
  }
}

DateTime? parseUnknownDate(String input) {
  final formats = [
    DateFormat('yyyy-MM-dd'), // ISO
    DateFormat('d.M.y'),     // EU
    DateFormat('M/d/y'),     // US
  ];

  for (var f in formats) {
    final dt = f.tryParse(input);
    if (dt != null) return dt;
  }

  return null;
}

String formatUnknownDate(DateTime dt) {
  String format = navi.prefs.getString("DateFormat")!;
  DateFormat df = switch(format) {
    "EU" => DateFormat('d.M.y'),
    "US" => DateFormat('M/d/y'),
    "ISO" || _ => DateFormat('yyyy-MM-dd'),
  };

  return df.format(dt);
}

TimeOfDay? parseTime(String input) {
  final dt = DateFormat('HH:mm').tryParse(input);
  if (dt == null) return null;
  return TimeOfDay.fromDateTime(dt);
}

String formatTime(TimeOfDay tod) {
  return "${tod.hour.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}";
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