library navigation;

/*
 * dart:html is only supported on Web
 * universal_html be used for localStorage on other platforms such as Android
 */

import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_slot_service.dart' as server;
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import "package:universal_html/html.dart" as html;
import 'package:yaml/yaml.dart';

Session? session;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();

Future<void> connect() async {
  final configString = await rootBundle.loadString('cptclient.yaml');
  final dynamic configMap = loadYaml(configString);

  html.window.localStorage.putIfAbsent('ServerScheme', () => configMap['ServerScheme']);
  html.window.localStorage.putIfAbsent('ServerHost', () => configMap['ServerHost']);
  html.window.localStorage.putIfAbsent('ServerPort', () => configMap['ServerPort']);
  html.window.localStorage.putIfAbsent('Session', () => '');
  html.window.localStorage.putIfAbsent('Token', () => '');
  html.window.localStorage.putIfAbsent('DefaultUser', ()=>'');
  html.window.localStorage.putIfAbsent('DefaultSlot', ()=>'');
  html.window.localStorage.putIfAbsent('DefaultCourse', ()=>'');
  html.window.localStorage.putIfAbsent('LoginLocationCache', ()=>'');

  if (await server.loadStatus()) {
    await server.loadCache();
    gotoRoute('/login');
  } else {
    gotoRoute('/config');
  }
}

Future<void> loginUser() async {
  if (await server.loadStatus()) {
    if (await confirmUser()) {
      gotoRoute('/user');
    }
  } else {
    gotoRoute('/config');
  }
}

Future<void> loginSlot() async {
  if (await server.loadStatus()) {
    if (await confirmSlot()) {
      gotoRoute('/slot');
    }
  } else {
    gotoRoute('/config');
  }
}

Future<void> logout() async {
  html.window.localStorage['Session'] = "";
  html.window.localStorage['Token'] = "";
  session = null;

  if (await server.loadStatus()) {
    await server.loadCache();
    gotoRoute('/login');
  } else {
    gotoRoute('/config');
  }
}

Future<bool> confirmUser() async {
  if (html.window.localStorage['Token']! == "") return false;

  session = Session(
    html.window.localStorage['Token']!,
  );

  User? user = await server.user_info(session!);
  if (user == null) return false;
  session!.user = user;

  Right? right = await server.right_info(session!);
  if (right == null) return false;
  session!.right = right;

  return true;
}

Future<bool> confirmSlot() async {
  if (html.window.localStorage['Token']! == "") return false;

  Slot? slot = await server.slot_info(html.window.localStorage['Token']!);
  if (slot == null) return false;

  session = Session(html.window.localStorage['Token']!, slot: slot);
  return true;
}

void gotoRoute(String targetroute) {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(targetroute, (route) => false);
}

