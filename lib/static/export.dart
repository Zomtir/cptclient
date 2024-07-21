import 'dart:convert';
import 'dart:io';

import 'package:cptclient/static/html.dart' if (dart.library.html) 'dart:html' as html;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';

exportQR(String fileName, Uint8List image) async {
  if (kIsWeb) {
    await _createOutputDownload(fileName, Uri.dataFromBytes(image as List<int>, mimeType: 'image/png'));
  } else {
    final outputFile = await _createOutputFile("$fileName.png");
    await outputFile?.writeAsBytes(image as List<int>);
  }
}

exportCSV(String fileName, List<String> table) async {
  String content = table.join('\n');

  if (kIsWeb) {
    await _createOutputDownload(fileName, Uri.dataFromString(content, mimeType: 'text/csv', encoding: utf8));
  } else {
    final outputFile = await _createOutputFile("$fileName.csv");
    await outputFile?.writeAsString(content, encoding: const Utf8Codec());
  }
}

Future<void> _createOutputDownload(String fileName, Uri fileData) async {
  html.AnchorElement()
    ..href = '$fileData'
    ..download = fileName
    ..style.display = 'none'
    ..click();
}

Future<File?> _createOutputFile(String fileName) async {
  String? filePath = (await getDirectoryPath(
  ));

  if (filePath == null) return null;

  return File("$filePath/$fileName");
}
