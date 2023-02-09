import 'dart:convert';

import "package:universal_html/html.dart"; // TODO go back to dart:html?
import 'package:http/http.dart' as http;

import 'package:cptclient/static/crypto.dart' as crypto;
import 'package:cptclient/json/user.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/branch.dart';
import 'package:cptclient/json/credential.dart';

String serverScheme = window.localStorage['ServerScheme']!;
String serverHost = window.localStorage['ServerHost']!;
int serverPort = int.tryParse(window.localStorage['ServerPort']!)?? 443;

Uri uri([String? path, Map<String, dynamic>? queryParameters]) {
  return Uri(
      scheme: serverScheme,
      host: serverHost,
      port: serverPort,
      path: path,
      queryParameters: queryParameters);
}

List<User> cacheMembers = [];
List<Location> cacheLocations = [];
List<Branch> cacheBranches = [];

Future<bool> loadStatus() async {
  final response;

  try {
    response = await http.head(uri('status'));
  } on Exception {
    return false;
  }

  return (response.statusCode == 200);
}

Future<bool> loadCache() async {
  // We are at the splash screen
  if (!await loadStatus()) {
    // Connection fails
    return false;
  } else {
    // Connection succeeds
    await loadLocations();
    await loadBranches();
    await Future.delayed(Duration(milliseconds: 200));
    return true;
  }
}

void refresh() {
  loadMembers();
  loadBranches();
  loadLocations();
}

Future<bool> loadMembers() async {
  final response = await http.get(
    uri('/member/user_list'),
    headers: {
      'Token': window.localStorage['Token']!,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return false;

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  cacheMembers = List<User>.from(l.map((model) => User.fromJson(model)));

  return true;
}

void unloadMembers() {
  cacheMembers = [];
}

Future<bool> loadLocations() async {
  final response = await http.get(
    uri('location_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return false;

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  cacheLocations = List<Location>.from(l.map((model) => Location.fromJson(model)));

  return true;
}

Future<bool> loadBranches() async {
  final response = await http.get(
    uri('branch_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return false;

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  cacheBranches = List<Branch>.from(l.map((model) => Branch.fromJson(model)));

  return true;
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
    window.localStorage['Token'] = response.body;
    return true;
  } else {
    print("User login error: ${response.headers["error-uri"]} error: ${response.headers["error-message"]}");
    return false;
  }
}

Future<bool> loginSlot(String key, String pwd) async {
  if (key.isEmpty || pwd.isEmpty) return false;

  Credential credential = Credential(key, pwd, "");

  final response = await http.post(
    uri('slot_login'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
    },
    body: json.encode(credential),
  );

  if (response.statusCode == 200) {
    window.localStorage['Token'] = response.body;
    return true;
  } else {
    print("Slot login error: ${response.headers["error-uri"]} error: ${response.headers["error-message"]}");
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
    window.localStorage['Token'] = response.body;
    return true;
  } else {
    print("Location login error: ${response.headers["error-uri"]} error: ${response.headers["error-message"]}");
    return false;
  }
}