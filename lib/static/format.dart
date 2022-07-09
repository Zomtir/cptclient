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

String niceDateTime(DateTime dt) {
  return DateFormat("dd MMM yyyy HH:mm").format(dt);
}
