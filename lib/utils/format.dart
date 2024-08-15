library format;

import 'package:cptclient/utils/datetime.dart';
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

String? formatNaiveDate(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").format(dt.toUtc());
}

DateTime? parseNaiveDate(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").parse(dt, true).toLocal();
}

String? formatNaiveDateTime(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt.toUtc());
}

DateTime? parseNaiveDateTime(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dt, true).toLocal();
}

String? formatWebDate(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").format(dt.toUtc());
}

DateTime? parseWebDate(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").parse(dt, true).toLocal();
}

String? formatWebDateTime(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd-HH-mm").format(dt.toUtc());
}

DateTime? parseWebDateTime(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd-HH-mm").parse(dt, true).toLocal();
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
