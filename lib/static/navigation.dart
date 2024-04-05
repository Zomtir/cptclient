library navigation;

/*
 * dart:html is only supported on Web
 * universal_html be used for localStorage on other platforms such as Android
 */

import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/environment.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import "package:universal_html/html.dart" as html;
import 'package:yaml/yaml.dart';

Session? session;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();

Future<void> connect() async {
  // Simulate lag
  //await Future.delayed(const Duration(seconds: 10));
  final configString = await rootBundle.loadString('cptclient.yaml');
  final dynamic configMap = loadYaml(configString);

  html.window.localStorage.putIfAbsent('ServerScheme', () => Env.serverScheme.fromString() ?? configMap['ServerScheme']);
  html.window.localStorage.putIfAbsent('ServerHost', () => Env.serverHost.fromString() ?? configMap['ServerHost']);
  html.window.localStorage.putIfAbsent('ServerPort', () => Env.serverPort.fromInt()?.toString() ?? configMap['ServerPort']);
  html.window.localStorage.putIfAbsent('Session', () => '');
  html.window.localStorage.putIfAbsent('Token', () => '');
  html.window.localStorage.putIfAbsent('DefaultUser', ()=>'');
  html.window.localStorage.putIfAbsent('DefaultEvent', ()=>'');
  html.window.localStorage.putIfAbsent('DefaultCourse', ()=>'');
  html.window.localStorage.putIfAbsent('DefaultLocation', ()=>'');

  if (await server.loadStatus()) {
    gotoRoute('/login');
  } else {
    gotoRoute('/config');
  }
}

Future<void> loginUser() async {
  if (await server.loadStatus()) {
    if (await confirmUser()) {
      gotoRoute('/user');
    } else {
      logout();
    }
  } else {
    gotoRoute('/config');
  }
}

Future<void> loginEvent() async {
  if (await server.loadStatus()) {
    if (await confirmEvent()) {
      gotoRoute('/event');
    } else {
      logout();
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

Future<bool> confirmEvent() async {
  if (html.window.localStorage['Token']!.isEmpty) return false;

  session = Session(html.window.localStorage['Token']!);
  return true;
}

void gotoRoute(String targetroute) {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(targetroute, (route) => false);
}

