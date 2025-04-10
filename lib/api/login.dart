import 'dart:convert';

import 'package:cptclient/api/anon/user.dart' as api_anon;
import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/crypto.dart' as crypto;
import 'package:http/http.dart' as http;

Future<bool> loadStatus() async {
  final http.Response response;

  try {
    response = await client.head(uri('status')).timeout(const Duration(seconds: 3));
  } on Exception {
    return false;
  }

  return (response.statusCode == 200);
}

Future<UserSession?> loginUser(String key, String pwd) async {
  if (key.isEmpty || pwd.isEmpty) return null;

  String? salt = await api_anon.user_salt(key);
  if (salt == null || salt.isEmpty) return null;

  Credential credential = Credential(login: key, password: crypto.hashPassword(pwd, salt), salt: salt);

  final response = await client.post(
    uri('/user_login'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
    },
    body: json.encode(credential),
  );

  if (response.statusCode != 200) {
    print("User login error: ${response.headers["error-uri"]} error: ${response.headers["error-msg"]}");
    return null;
  }

  return UserSession(key,response.body,DateTime.now().add(Duration(hours: 3)));
}

Future<EventSession?> loginEvent(String key, String pwd) async {
  if (key.isEmpty || pwd.isEmpty) return null;

  Credential credential = Credential(login: key, password: pwd);

  final response = await client.post(
    uri('/event_login'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
    },
    body: json.encode(credential),
  );

  if (response.statusCode != 200) {
    print("Event login error: ${response.headers["error-uri"]} error: ${response.headers["error-msg"]}");
    return null;
  }

  return EventSession(key,response.body,DateTime.now().add(Duration(hours: 3)));
}

Future<EventSession?> loginCourse(String key) async {
  if (key.isEmpty) return null;

  final response = await client.get(
    uri('/course_login', {'course_key': key}),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (response.statusCode != 200) {
    print("Event login error: ${response.headers["error-uri"]} error: ${response.headers["error-msg"]}");
    return null;
  }

  return EventSession(key,response.body,DateTime.now().add(Duration(hours: 3)));
}

Future<EventSession?> loginLocation(String key) async {
  if (key.isEmpty) return null;

  final response = await client.get(
    uri('/location_login', {'location_key': key}),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (response.statusCode != 200) {
    print("Event login error: ${response.headers["error-uri"]} error: ${response.headers["error-msg"]}");
    return null;
  }

  return EventSession(key,response.body,DateTime.now().add(Duration(hours: 3)));
}