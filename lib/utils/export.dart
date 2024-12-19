import 'dart:convert';
import 'dart:io';

import 'package:cptclient/utils/html.dart' if (dart.library.html) 'dart:html' as html;
import 'package:cptclient/utils/platform.dart';
import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';

exportPNG(String fileName, Uint8List image) async {
  await saveSelector(
    content: image,
    fileExtension: 'png',
    fileName: fileName,
    mimeType: 'image/png',
  );
}

Future<void> exportCSV(fileName, List<List<dynamic>> table) async {
  const converter = ListToCsvConverter();
  final content = converter.convert(table);
  await saveSelector(
    content: content,
    fileExtension: 'csv',
    fileName: fileName,
    mimeType: 'text/csv',
  );
}

exportPDF(String fileName, Uint8List doc) async {
  await saveSelector(
    content: doc,
    fileExtension: 'pdf',
    fileName: fileName,
    mimeType: 'application/pdf',
  );
}

Future<void> saveSelector<T>({
  required T content,
  required String mimeType,
  required String fileName,
  required String fileExtension,
}) async {
  if (kIsWeb) {
    final Uri uri;
    if (content is String) {
      uri = Uri.dataFromString(content, mimeType: mimeType, encoding: utf8);
    } else if (content is List<int>) {
      uri = Uri.dataFromBytes(content, mimeType: mimeType);
    } else {
      throw UnimplementedError('Data type not supported: $T');
    }
    html.AnchorElement()
      ..href = uri.toString()
      ..download = fileName
      ..style.display = 'none'
      ..click();
  } else {
    String? outputPath;
    if (isDesktop) {
      outputPath = (await getSaveLocation(suggestedName: '$fileName.$fileExtension'))?.path;
    } else {
      String? filePath = await getDirectoryPath();
      if (filePath == null) return;
      outputPath = '$filePath/$fileName.$fileExtension';
    }
    if (outputPath == null) return;
    final outputFile = File(outputPath);

    if (content is String) {
      await outputFile.writeAsString(content, encoding: const Utf8Codec());
    } else if (content is List<int>) {
      await outputFile.writeAsBytes(content);
    } else {
      throw UnimplementedError('Data type not supported: $T');
    }
  }
}
