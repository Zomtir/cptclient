import 'package:flutter/services.dart';

void clipText(String text) {
  Clipboard.setData(ClipboardData(text: text));
}
