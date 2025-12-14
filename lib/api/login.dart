import 'dart:convert';

import 'package:cptclient/api/anon/user.dart' as api_anon;
import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/crypto.dart' as crypto;
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

Future<Result<UserSession>> loginUser(String key, String pwd) async {
  if (key.isEmpty || pwd.isEmpty) return Failure();

  Result<String> result_salt = await api_anon.user_salt(key);
  if (result_salt is! Success) return Failure();
  var salt = result_salt.unwrap();

  Credential credential = Credential(login: key, password: crypto.hashPassword(pwd, salt), salt: salt);

  final response = await client.post(
    uri('/user_login'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
    },
    body: json.encode(credential),
  );

  if (handleFailedResponse(response)) return Failure();

  var session = UserSession(key,response.body,DateTime.now().add(Duration(hours: 3)));
  return Success(session);
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

  var object = EventSession(key,response.body,DateTime.now().add(Duration(hours: 3)));
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

  var session = EventSession(key,response.body,DateTime.now().add(Duration(hours: 3)));
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

  var session = EventSession(key,response.body,DateTime.now().add(Duration(hours: 3)));
  return Success(session);
}