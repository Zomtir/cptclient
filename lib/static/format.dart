library format;

import 'package:cptclient/static/datetime.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String compressDate(BuildContext context, DateTime begin, DateTime end) {
  String strBegin = begin.fmtDateTime(context);
  String strEnd;

  if (begin.day == end.day) {
    strEnd = end.fmtTime(context);
  } else {
    strEnd = end.fmtDateTime(context);
  }

  return "$strBegin - $strEnd";
}

DateTime? parseNaiveDateTime(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dt, true).toLocal();
}

String? formatNullWebDateTime(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd-HH-mm").format(dt.toUtc());
}

DateTime? parseNullWebDateTime(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd-HH-mm").parse(dt, true).toLocal();
}

String? formatNullWebDate(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").format(dt.toUtc());
}

DateTime? parseNullWebDate(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").parse(dt, true).toLocal();
}

String? formatNullInt(int? i) {
  return i?.toString();
}

int? parseNullInt(String? i) {
  return i == null ? null : int.tryParse(i);
}

int? convertNullInt(int? i) {
  return i;
}
