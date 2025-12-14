// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<Event>> event_info(EventSession session) async {
  final response = await client.get(
    uri('/service/event_info'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var event = Event.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  return Success(event);
}

Future<Result> event_note_edit(EventSession session, String note) async {
  final response = await client.post(
    uri('/service/event_note_edit'),
    headers: {
      'Token': session.token,
      'Content-Type': 'text/plain; charset=utf-8',
    },
    body: utf8.encode(note),
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}

Future<Result<List<User>>> event_attendance_presence_pool(EventSession session, String role) async {
  final response = await client.get(
    uri('/service/event_attendance_presence_pool', {
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<User>.from(it.map((model) => User.fromJson(model)));
  return Success(list);
}

Future<Result<List<User>>> event_attendance_presence_list(EventSession session, String role) async {
  final response = await client.get(
    uri('/service/event_attendance_presence_list', {
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<User>.from(it.map((model) => User.fromJson(model)));
  return Success(list);
}

Future<Result> event_attendance_presence_add(EventSession session, User user, String role) async {
  final response = await client.head(
    uri('/service/event_attendance_presence_add', {
      'user_id': user.id.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}

Future<Result> event_attendance_presence_remove(EventSession session, User user, String role) async {
  final response = await client.head(
    uri('/service/event_attendance_presence_remove', {
      'user_id': user.id.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}
