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

String? formatIsoTime(DateTime? dt) {
  return dt == null ? null : DateFormat("HH:mm:ss").format(dt);
}

String? formatIsoDate(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").format(dt);
}

DateTime? parseIsoDate(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").parse(dt, true);
}

String? formatIsoDateTime(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt);
}

DateTime? parseIsoDateTime(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dt, true);
}

String? formatWebDate(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").format(dt);
}

DateTime? parseWebDate(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").parse(dt, true);
}

String? formatWebDateTime(DateTime? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd-HH-mm").format(dt);
}

DateTime? parseWebDateTime(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd-HH-mm").parse(dt, true);
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
