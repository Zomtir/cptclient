// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Organisation>>> organisation_list() async {
  final response = await client.get(
    uri('/anon/organisation_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Organisation>.from(it.map((model) => Organisation.fromJson(model)));
  return Success(list);
}