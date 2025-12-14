// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<User>>> event_owner_list(UserSession session, Event event) async {
  final response = await client.get(
    uri('/mod/event_owner_list', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var list = List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
  return Success(list);
}

Future<Result> event_owner_add(UserSession session, Event event, User user) async {
  final response = await client.head(
    uri('/mod/event_owner_add', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> event_owner_remove(UserSession session, Event event, User user) async {
  final response = await client.head(
    uri('/mod/event_owner_remove', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
   return
  Success
  (
  (
  )
  );
}
