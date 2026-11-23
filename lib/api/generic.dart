// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:http/http.dart' as http;

Future<Result> loadStatus() async {
  final http.Response response;

  try {
    response = await client.head(uri('status')).timeout(const Duration(seconds: 3));
  } on Exception {
    return Failure();
  }

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<String>> loadVersion() async {
  final response = await client.get(
    uri('/version'),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(utf8.decode(response.bodyBytes));
}
