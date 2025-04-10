// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';

Future<String?> user_salt(String key) async {
  final response = await client.get(
    uri('/anon/user_salt', {
      'user_key': key,
    }),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return utf8.decode(response.bodyBytes);
}