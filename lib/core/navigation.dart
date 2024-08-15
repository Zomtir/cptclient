library navigation;

import 'package:cptclient/api/login.dart' as api;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/core/client.dart';
import 'package:cptclient/core/environment.dart';
import 'package:cptclient/core/router.dart' as router;
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

late SharedPreferences prefs;
UserSession? uSession;
EventSession? eSession;

Future<void> preferences() async {
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
  await putMissingString('UserToken', '');
  await putMissingString('EventToken', '');
  await putMissingString('UserDefault', '');
  await putMissingString('EventDefault', '');
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

Future<void> loginUser(BuildContext context, String token) async {
  if (await api.loadStatus()) {
    if (await confirmUser(token)) {
      router.gotoRoute(context, '/user');
    } else {
      logoutUser(context);
    }
  } else {
    router.gotoRoute(context, '/connect');
  }
}

Future<void> logoutUser(BuildContext context) async {
  await prefs.setString('UserToken', '');
  uSession = null;

  if (await api.loadStatus()) {
    router.gotoRoute(context, '/login');
  } else {
    router.gotoRoute(context, '/connect');
  }
}

Future<void> loginEvent(BuildContext context, String token) async {
  if (await api.loadStatus()) {
    if (await confirmEvent(token)) {
      router.gotoRoute(context, '/event');
    } else {
      logoutEvent(context);
    }
  } else {
    router.gotoRoute(context, '/connect');
  }
}

Future<void> logoutEvent(BuildContext context) async {
  await prefs.setString('EventToken', '');
  uSession = null;

  if (await api.loadStatus()) {
    router.gotoRoute(context, '/login');
  } else {
    router.gotoRoute(context, '/connect');
  }
}

Future<bool> confirmUser(String token) async {
  if (token.isEmpty) return false;
  await prefs.setString('UserToken', token);
  uSession = UserSession(token);

  User? user = await api_regular.user_info(uSession!);
  if (user == null) return false;
  uSession!.user = user;

  Right? right = await api_regular.right_info(uSession!);
  if (right == null) return false;
  uSession!.right = right;

  return true;
}

Future<bool> confirmEvent(String token) async {
  if (token.isEmpty) return false;
  await prefs.setString('EventToken', token);
  eSession = EventSession(token);

  return true;
}
