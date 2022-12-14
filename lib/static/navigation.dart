library navigation;

import 'package:flutter/material.dart';

import "package:universal_html/html.dart"; // TODO go back to dart:html?
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cptclient/static/db.dart' as db;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';

String server = window.localStorage['ServerURL']!;
Session? session;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();

void connect() async {
  if (await loadStatus()) {
    await loadCache();
    gotoRoute('/login');
  } else {
    gotoRoute('/config');
  }
}

void loginUser() async {
  if (await loadStatus()) {
    if (await confirmUser()) {
      gotoRoute('/user');
    }
  } else {
    gotoRoute('/config');
  }
}

void logout() async {
  window.localStorage['Token'] = "";
  session = null;
  db.unloadMembers();

  if (await loadStatus()) {
    await loadCache();
    gotoRoute('/login');
  } else {
    gotoRoute('/config');
  }
}

Future<bool> loadStatus() async {
  final response;

  try {
    response = await http.head(Uri.http(server, 'status'));
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
    await db.loadLocations();
    await db.loadBranches();
    await db.loadAccess();
    await Future.delayed(Duration(milliseconds: 200));
    return true;
  }
}

Future<bool> confirmUser() async {
  if (window.localStorage['Token']! == "") return false;

  final response = await http.get(
    Uri.http(server, 'user_info'),
    headers: {
      'Token': window.localStorage['Token']!,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return false;

  User user = User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  session = Session(window.localStorage['Token']!, user: user);

  db.loadMembers();
  return true;
}

Future<bool> confirmSlot() async {
  if (window.localStorage['Token']! == "") return false;

  final response = await http.get(
    Uri.http(server, 'slot_info'),
    headers: {
      'Token': window.localStorage['Token']!,
    },
  );

  if (response.statusCode != 200) return false;

  Slot slot = Slot.fromJson(json.decode(response.body));

  session = Session(window.localStorage['Token']!, slot: slot);
  return true;
}

void gotoRoute(String targetroute) {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(targetroute, (route) => false);
}

void refresh() {
  db.loadMembers();
  db.loadAccess();
  db.loadBranches();
  db.loadLocations();
}
