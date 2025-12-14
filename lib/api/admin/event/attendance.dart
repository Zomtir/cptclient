// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<User>>> event_attendance_registration_list(UserSession session, Event event, String role) async {
  final response = await client.get(
    uri('/admin/event_attendance_registration_list', {
      'event_id': event.id.toString(),
      'role': role,
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

Future<Result<List<(User, bool)>>> event_attendance_filter_list(UserSession session, int eventID, String role) async {
  final response = await client.get(
    uri('/admin/event_attendance_filter_list', {
      'event_id': eventID.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<(User, bool)>.from(
    it.map((model) {
      return (
        User.fromJson(model[0]),
        model[1],
      );
    }),
  );
  return Success(list);
}

Future<Result> event_attendance_filter_edit(UserSession session, int eventID, int userID, String role, bool access) async {
  final response = await client.head(
    uri('/admin/event_attendance_filter_edit', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
      'role': role,
      'access': access.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> event_attendance_filter_remove(UserSession session, int eventID, int userID, String role) async {
  final response = await client.head(
    uri('/admin/event_attendance_filter_remove', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<List<User>>> event_attendance_presence_pool(UserSession session, Event event, String role) async {
  final response = await client.get(
    uri('/admin/event_attendance_presence_pool', {
      'event_id': event.id.toString(),
      'role': role,
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

Future<Result<List<User>>> event_attendance_presence_list(UserSession session, Event event, String role) async {
  final response = await client.get(
    uri('/admin/event_attendance_presence_list', {
      'event_id': event.id.toString(),
      'role': role,
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<User>.from(it.map((data) => User.fromJson(data)));
  return Success(list);
}

Future<Result> event_attendance_presence_add(UserSession session, Event event, User user, String role) async {
  final response = await client.head(
    uri('/admin/event_attendance_presence_add', {
      'event_id': event.id.toString(),
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

Future<Result> event_attendance_presence_remove(UserSession session, Event event, User user, String role) async {
  final response = await client.head(
    uri('/admin/event_attendance_presence_remove', {
      'event_id': event.id.toString(),
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
