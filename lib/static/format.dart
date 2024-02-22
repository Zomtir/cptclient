library format;

import 'package:intl/intl.dart';

String compressDate(DateTime begin, DateTime end) {
  String strBegin = DateFormat("dd MMM yyyy HH:mm").format(begin);
  String strEnd;

  if (begin.day == end.day) {
    strEnd = DateFormat("HH:mm").format(end);
  } else {
    strEnd = DateFormat("dd MMM yyyy HH:mm").format(end);
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
