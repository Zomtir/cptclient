import 'dart:convert';

import 'package:cptclient/json/credential.dart';
import 'package:cptclient/static/client.dart';
import 'package:cptclient/static/crypto.dart' as crypto;
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

Future<String?> getUserSalt(String key) async {
  final response = await client.get(
    uri('/user_salt', {
      'user_key': key,
    }),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return utf8.decode(response.bodyBytes);
}

Future<String?> loginUser(String key, String pwd) async {
  if (key.isEmpty || pwd.isEmpty) return null;

  String? salt = await getUserSalt(key);
  if (salt == null || salt.isEmpty) return null;

  Credential credential = Credential(key, crypto.hashPassword(pwd, salt), salt);

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

  return response.body;
}

Future<String?> loginEvent(String key, String pwd) async {
  if (key.isEmpty || pwd.isEmpty) return null;

  Credential credential = Credential(key, pwd, "");

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

  return response.body;
}

Future<String?> loginCourse(String key) async {
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

  return response.body;
}

Future<String?> loginLocation(String key) async {
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

  return response.body;
}