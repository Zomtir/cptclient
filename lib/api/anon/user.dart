// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<String>> user_salt(String key) async {
  final response = await client.get(
    uri('/anon/user_salt', {
      'user_key': key,
    }),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(utf8.decode(response.bodyBytes));
}