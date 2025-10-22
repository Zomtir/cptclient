// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/club.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Club>>> club_list() async {
  final response = await client.get(
    uri('/anon/club_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var li = List<Club>.from(it.map((model) => Club.fromJson(model)));
  return Success(li);
}

Future<List<int>?> club_banner(int clubID) async {
  final response = await client.get(
    uri('/anon/club_banner', {
      'club_id': clubID.toString(),
    }),
    headers: {
      'Accept': 'image/png;',
    },
  );

  if (response.statusCode != 200) return null;

  return response.bodyBytes;
}
