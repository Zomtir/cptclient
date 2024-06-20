library navigation;

import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/main.dart';
import 'package:cptclient/static/environment.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

late GlobalKey<CptState> cptKey;
late SharedPreferences prefs;
UserSession? uSession;
EventSession? eSession;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();

Future<void> preferences(GlobalKey<CptState> key) async {
  final configString = await rootBundle.loadString('cptclient.yaml');
  final dynamic configMap = loadYaml(configString);

  cptKey = key;
  prefs = await SharedPreferences.getInstance();

  pufIfMissing(String key, String value) async {
    if (!prefs.containsKey(key)) await prefs.setString(key, value);
  }

  await pufIfMissing('Language', 'en');
  await pufIfMissing('ServerScheme', Env.serverScheme.fromString() ?? configMap['ServerScheme']);
  await pufIfMissing('ServerHost', Env.serverHost.fromString() ?? configMap['ServerHost']);
  await pufIfMissing('ServerPort', Env.serverPort.fromInt()?.toString() ?? configMap['ServerPort']);
  await pufIfMissing('UserToken', '');
  await pufIfMissing('EventToken', '');
  await pufIfMissing('UserDefault', '');
  await pufIfMissing('EventDefault', '');
}

applyLocale(BuildContext context) {
  print(cptKey.currentState);
  print(prefs.getString('Language'));
  context.findAncestorStateOfType<CptState>()!.setLocale(Locale(prefs.getString('Language')!));
}

applyServer() {
  prefs.reload();
  server.configServer(
    prefs.getString('ServerScheme')!,
    prefs.getString('ServerHost')!,
    int.tryParse(prefs.getString('ServerPort')!) ?? 0,
  );
}

Future<void> connectServer() async {
  // Simulate lag
  //await Future.delayed(const Duration(seconds: 10));

  if (await server.loadStatus()) {
    gotoRoute('/login');
  } else {
    gotoRoute('/connect');
  }
}

Future<void> loginUser(String token) async {
  if (await server.loadStatus()) {
    if (await confirmUser(token)) {
      gotoRoute('/user');
    } else {
      logoutUser();
    }
  } else {
    gotoRoute('/connect');
  }
}

Future<void> loginEvent(String token) async {
  if (await server.loadStatus()) {
    if (await confirmEvent(token)) {
      gotoRoute('/event');
    } else {
      logoutEvent();
    }
  } else {
    gotoRoute('/connect');
  }
}

Future<void> logoutUser() async {
  await prefs.setString('UserToken', '');
  uSession = null;

  if (await server.loadStatus()) {
    gotoRoute('/login');
  } else {
    gotoRoute('/connect');
  }
}

Future<void> logoutEvent() async {
  await prefs.setString('EventToken', '');
  uSession = null;

  if (await server.loadStatus()) {
    gotoRoute('/login');
  } else {
    gotoRoute('/connect');
  }
}

Future<bool> confirmUser(String token) async {
  if (token.isEmpty) return false;
  await prefs.setString('UserToken', token);
  uSession = UserSession(token);

  User? user = await server.user_info(uSession!);
  if (user == null) return false;
  uSession!.user = user;

  Right? right = await server.right_info(uSession!);
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

void gotoRoute(String path) {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(path, (route) => false);
}
