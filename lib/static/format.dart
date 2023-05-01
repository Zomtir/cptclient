library format;

import 'package:intl/intl.dart';

String compressDate(DateTime begin, DateTime end) {

  String strBegin = DateFormat("dd MMM yyyy HH:mm").format(begin);
  String strEnd;

  if (begin.day == end.day)
    strEnd = DateFormat("HH:mm").format(end);
  else
    strEnd = DateFormat("dd MMM yyyy HH:mm").format(end);

  return "$strBegin - $strEnd";
}

String niceDate(DateTime dt) {
  return DateFormat("dd MMM yyyy").format(dt);
}

String niceDateTime(DateTime dt) {
  return DateFormat("dd MMM yyyy HH:mm").format(dt);
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

DateTime? parseWebDate(String? dt) {
  return dt == null ? null : DateFormat("yyyy-MM-dd").parse(dt, true).toLocal();
}

String? formatNullInt(int? i) {
  return i == null ? null : i.toString();
}

int? parseNullInt(String? i) {
  return i == null ? null : int.tryParse(i);
}
