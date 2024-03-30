import 'dart:convert';

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/static/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import "package:universal_html/html.dart" as html;

String serverScheme = html.window.localStorage['ServerScheme']!;
String serverHost = html.window.localStorage['ServerHost']!;
int serverPort = int.tryParse(html.window.localStorage['ServerPort']!)?? 443;

Uri uri([String? path, Map<String, dynamic>? queryParameters]) {
  return Uri(
      scheme: serverScheme,
      host: serverHost,
      port: serverPort,
      path: path,
      queryParameters: queryParameters);
}

List<Status> cacheEventStatus = [Status.OCCURRING, Status.DRAFT, Status.PENDING, Status.REJECTED, Status.CANCELED];

Future<bool> loadStatus() async {
  final http.Response response;

  try {
    response = await http.head(uri('status')).timeout(const Duration(seconds: 3));
  } on Exception {
    return false;
  }

  return (response.statusCode == 200);
}

Future<List<Course>> receiveCourses() async {
  final response = await http.get(
    uri('/anon/course_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  List<Course> courses = List<Course>.from(l.map((model) => Course.fromJson(model)));

  return courses;
}

Future<String?> getUserSalt(String key) async {
  final response = await http.get(
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

Future<bool> loginUser(String key, String pwd) async {
  if (key.isEmpty || pwd.isEmpty) return false;

  String? salt = await getUserSalt(key);
  if (salt == null || salt.isEmpty) return false;

  Credential credential = Credential(key, crypto.hashPassword(pwd, salt), salt);

  final response = await http.post(
    uri('user_login'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
    },
    body: json.encode(credential),
  );

  if (response.statusCode == 200) {
    html.window.localStorage['Session'] = 'user';
    html.window.localStorage['Token'] = response.body;
    return true;
  } else {
    print("User login error: ${response.headers["error-uri"]} error: ${response.headers["error-msg"]}");
    return false;
  }
}

Future<bool> loginEvent(String key, String pwd) async {
  if (key.isEmpty || pwd.isEmpty) return false;

  Credential credential = Credential(key, pwd, "");

  final response = await http.post(
    uri('event_login'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
    },
    body: json.encode(credential),
  );

  if (response.statusCode == 200) {
    html.window.localStorage['Session'] = 'event';
    html.window.localStorage['Token'] = response.body;
    return true;
  } else {
    print("Event login error: ${response.headers["error-uri"]} error: ${response.headers["error-msg"]}");
    return false;
  }
}

Future<bool> loginCourse(String key) async {
  if (key.isEmpty) return false;

  final response = await http.get(
    uri('course_login', {'course_key': key}),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (response.statusCode == 200) {
    html.window.localStorage['Session'] = 'event';
    html.window.localStorage['Token'] = response.body;
    return true;
  } else {
    print("Course login error: ${response.headers["error-uri"]} error: ${response.headers["error-msg"]}");
    return false;
  }
}

Future<bool> loginLocation(String key) async {
  if (key.isEmpty) return false;

  final response = await http.get(
    uri('location_login', {'location_key': key}),
    headers: {
      'Accept': 'text/plain; charset=utf-8',
    },
  );

  if (response.statusCode == 200) {
    html.window.localStorage['Session'] = 'event';
    html.window.localStorage['Token'] = response.body;
    return true;
  } else {
    print("Location login error: ${response.headers["error-uri"]} error: ${response.headers["error-msg"]}");
    return false;
  }
}