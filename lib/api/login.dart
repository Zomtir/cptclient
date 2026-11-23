// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<(int, String)>> loginUser(String key, Credential credential) async {
  final response = await client.post(
    uri('/user_login'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
    },
    body: json.encode(credential),
  );

  if (handleFailedResponse(response)) return Failure();

  final [int id, String token] = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

  return Success((id, token));
}

Future<Result<Right>> user_session_right(UserSession session) async {
  final response = await client.get(
    uri('/user_session_right'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var right = Right.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  return Success(right);
}

Future<Result<EventSession>> loginEvent(String key, String pwd) async {
  if (key.isEmpty || pwd.isEmpty) return Failure();

  Credential credential = Credential(login: key, password: pwd);

  final response = await client.post(
    uri('/event_login'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
    },
    body: json.encode(credential),
  );

  if (handleFailedResponse(response)) return Failure();

  var object = EventSession(key, response.body, DateTime.now().add(Duration(hours: 3)));
  return Success(object);
}

Future<Result<EventSession>> loginCourse(String key) async {
  if (key.isEmpty) return Failure();

  final response = await client.get(
    uri('/course_login', {'course_key': key}),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var session = EventSession(key, response.body, DateTime.now().add(Duration(hours: 3)));
  return Success(session);
}

Future<Result<EventSession>> loginLocation(String key) async {
  if (key.isEmpty) return Failure();

  final response = await client.get(
    uri('/location_login', {'location_key': key}),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var session = EventSession(key, response.body, DateTime.now().add(Duration(hours: 3)));
  return Success(session);
}
