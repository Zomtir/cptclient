import 'dart:io';

import 'package:cptclient/static/html.dart' if (dart.library.html) 'dart:html' as html;
import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/foundation.dart';

exportQR(String filename, Uint8List image) async {


  if (kIsWeb) {
    html.AnchorElement()
      ..href = '${Uri.dataFromBytes(image as List<int>, mimeType: 'image/png')}'
      ..download = filename
      ..style.display = 'none'
      ..click();
  } else {
    String? outputPath = (await file_selector.getSaveLocation(suggestedName: filename))?.path;
    if (outputPath != null) {
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(image as List<int>);
    }
  }
}

exportCSV(String fileName, List<String> table) async {
  String content = table.join('\n');

  if (kIsWeb) {
    html.AnchorElement()
      ..href = '${Uri.dataFromString(content, mimeType: 'text/csv')}'
      ..download = fileName
      ..style.display = 'none'
      ..click();
  } else {
    String? outputPath = (await file_selector.getSaveLocation(suggestedName: fileName))?.path;
    if (outputPath != null) {
      final outputFile = File(outputPath);
      await outputFile.writeAsString(content);
    }
  }
}