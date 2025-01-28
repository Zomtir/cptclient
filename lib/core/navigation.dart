import 'dart:convert';

import 'package:cptclient/api/login.dart' as api;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/core/client.dart';
import 'package:cptclient/core/environment.dart';
import 'package:cptclient/core/router.dart' as router;
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

final GlobalKey<NavigatorState> naviKey = GlobalKey<NavigatorState>();

late SharedPreferences prefs;

List<Credential> userCredentials = [];
List<Credential> eventCredentials = [];

List<UserSession> userSessions = [];
List<EventSession> eventSessions = [];

UserSession? userSession;
EventSession? eventSession;

Future<void> initPreferences() async {
  final configString = await rootBundle.loadString('cptclient.yaml');
  final dynamic configMap = loadYaml(configString);

  prefs = await SharedPreferences.getInstance();

  putMissingString(String key, String value) async {
    if (!prefs.containsKey(key)) await prefs.setString(key, value);
  }

  putMissingInt(String key, int value) async {
    if (!prefs.containsKey(key)) await prefs.setInt(key, value);
  }

  await putMissingString('Language', 'en');
  await putMissingString('ServerScheme', Env.serverScheme.fromString() ?? configMap['ServerScheme']);
  await putMissingString('ServerHost', Env.serverHost.fromString() ?? configMap['ServerHost']);
  await putMissingInt('ServerPort', Env.serverPort.fromInt() ?? int.tryParse(configMap['ServerPort'])!);
  await putMissingString('ClientScheme', Env.clientScheme.fromString() ?? configMap['ClientScheme']);
  await putMissingString('ClientHost', Env.clientHost.fromString() ?? configMap['ClientHost']);
  await putMissingInt('ClientPort', Env.clientPort.fromInt() ?? int.tryParse(configMap['ClientPort'])!);
  await putMissingString('UserSessions', '');
  await putMissingString('EventSessions', '');
  await putMissingString('UserCredentials', '');
  await putMissingString('EventCredentials', '');
}

List<T> _decodeList<T> (String prefString, T Function(Map<String, dynamic>) fromJson) {
  String encoded = utf8.decode(base64Decode(prefs.getString(prefString)!));
  Iterable usList = encoded.isNotEmpty ? json.decode(encoded) : [];
  return List<T>.from(usList.map((entry) => fromJson(entry)));
}

void _encodeList<T> (String prefString, Function() toJson) {
  var json = jsonEncode(toJson().toList());
  prefs.setString(prefString, base64Encode(utf8.encode(json)));
}

applyCredentials() {
  userCredentials = _decodeList('UserCredentials', (entry) => Credential.fromJson(entry));
  eventCredentials = _decodeList('EventCredentials', (entry) => Credential.fromJson(entry));
}

addUserCredential(Credential credential) {
  userCredentials.add(credential);
  _encodeList('UserCredentials', () => userCredentials.map((e) => e.toJson()).toList());
}

removeUserCredential(Credential credential) {
  userCredentials.remove(credential);
  _encodeList('UserCredentials', () => userCredentials.map((e) => e.toJson()).toList());
}

addEventCredential(Credential credential) {
  eventCredentials.add(credential);
  _encodeList('EventCredentials', () => eventCredentials.map((e) => e.toJson()).toList());
}

removeEventCredential(Credential credential) {
  eventCredentials.remove(credential);
  _encodeList('EventCredentials', () => eventCredentials.map((e) => e.toJson()).toList());
}

applySessions() {
  userSessions = _decodeList('UserSessions', (entry) => UserSession.fromJson(entry));
  eventSessions = _decodeList('EventSessions', (entry) => EventSession.fromJson(entry));
}

addUserSession(UserSession session) {
  userSessions.add(session);
  var json = jsonEncode(userSessions.map((e) => e.toJson()).toList());
  prefs.setString('UserSessions', base64Encode(utf8.encode(json)));
}

removeUserSession(UserSession session) {
  userSessions.remove(session);
  var json = jsonEncode(userSessions.map((e) => e.toJson()).toList());
  prefs.setString('UserSessions', base64Encode(utf8.encode(json)));
}

addEventSession(EventSession session) {
  eventSessions.add(session);
  var json = jsonEncode(eventSessions.map((e) => e.toJson()).toList());
  prefs.setString('EventSessions', base64Encode(utf8.encode(json)));
}

removeEventSession(EventSession session) {
  eventSessions.remove(session);
  var json = jsonEncode(eventSessions.map((e) => e.toJson()).toList());
  prefs.setString('EventSessions', base64Encode(utf8.encode(json)));
}

applyLocale(BuildContext context) {
  context.findAncestorStateOfType<CptState>()!.setLocale(Locale(prefs.getString('Language')!));
}

applyServer() {
  prefs.reload();
  configServer(
    prefs.getString('ServerScheme')!,
    prefs.getString('ServerHost')!,
    prefs.getInt('ServerPort')!,
  );
}

Future<bool> loginUser(BuildContext context, UserSession uSession) async {
  if (uSession.token.isEmpty) return false;

  User? user = await api_regular.user_info(uSession);
  if (user == null) return false;
  uSession.user = user;

  Right? right = await api_regular.right_info(uSession);
  if (right == null) return false;
  uSession.right = right;

  userSession = uSession;
  router.gotoRoute(context, '/user');
  return true;
}

Future<void> logoutUser(BuildContext context) async {
  removeUserSession(userSession!);
  userSession = null;

  if (await api.loadStatus()) {
    router.gotoRoute(context, '/login');
  } else {
    router.gotoRoute(context, '/connect');
  }
}

Future<bool> loginEvent(BuildContext context, EventSession eSession) async {
  if (eSession.token.isEmpty) return false;

  eventSession = eSession;
  router.gotoRoute(context, '/event');
  return true;
}

Future<void> logoutEvent(BuildContext context) async {
  removeEventSession(eventSession!);
  eventSession = null;

  if (await api.loadStatus()) {
    router.gotoRoute(context, '/login');
  } else {
    router.gotoRoute(context, '/connect');
  }
}
