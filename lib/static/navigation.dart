library navigation;

import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_slot_service.dart' as server;
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import "package:universal_html/html.dart"; // TODO go back to dart:html?
import 'package:yaml/yaml.dart';

Session? session;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();

Future<void> connect() async {
  final configString = await rootBundle.loadString('cptclient.yaml');
  final dynamic configMap = loadYaml(configString);

  window.localStorage.putIfAbsent('ServerScheme', () => configMap['ServerScheme']);
  window.localStorage.putIfAbsent('ServerHost', () => configMap['ServerHost']);
  window.localStorage.putIfAbsent('ServerPort', () => configMap['ServerPort']);
  window.localStorage.putIfAbsent('Session', () => '');
  window.localStorage.putIfAbsent('Token', () => '');
  window.localStorage.putIfAbsent('DefaultUser', ()=>'');
  window.localStorage.putIfAbsent('DefaultSlot', ()=>'');
  window.localStorage.putIfAbsent('DefaultCourse', ()=>'');
  window.localStorage.putIfAbsent('LoginLocationCache', ()=>'');

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
  window.localStorage['Session'] = "";
  window.localStorage['Token'] = "";
  session = null;

  if (await server.loadStatus()) {
    await server.loadCache();
    gotoRoute('/login');
  } else {
    gotoRoute('/config');
  }
}

Future<bool> confirmUser() async {
  if (window.localStorage['Token']! == "") return false;

  session = Session(
    window.localStorage['Token']!,
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
  if (window.localStorage['Token']! == "") return false;

  Slot? slot = await server.slot_info(window.localStorage['Token']!);
  if (slot == null) return false;

  session = Session(window.localStorage['Token']!, slot: slot);
  return true;
}

void gotoRoute(String targetroute) {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(targetroute, (route) => false);
}

