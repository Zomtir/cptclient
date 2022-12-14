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
Session session = Session("");

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();

Future<bool> loadStatus() async {
  final response;

  try {
    response = await http.head(
      Uri.http(server, 'status'),
    );
  } on Exception {
    return false;
  }

  return (response.statusCode == 200);
}

void confirmUser() async {
  if (window.localStorage['Token']! == "") return;

  final response = await http.get(
    Uri.http(server, 'user_info'),
    headers: {
      'Token': window.localStorage['Token']!,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return;

  User user  = User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  session = Session(window.localStorage['Token']!, user: user);

  db.loadMembers();
  navigatorKey.currentState?.pushReplacementNamed('/user');
}

void confirmSlot() async {
  if (window.localStorage['Token']! == "") return;

  final response = await http.get(
    Uri.http(server, 'slot_info'),
    headers: {
      'Token': window.localStorage['Token']!,
    },
  );

  if (response.statusCode != 200) return;

  Slot slot = Slot.fromJson(json.decode(response.body));

  session= Session(window.localStorage['Token']!, slot: slot);
  navigatorKey.currentState?.pushReplacementNamed('/slot');
}

void refresh() {
  db.loadMembers();
  db.loadAccess();
  db.loadBranches();
  db.loadLocations();
}

Future<void> tryConnect() async {
  // We are at the splash screen
  if (!await loadStatus()) {
    // If connection fails, go the config page
    navigatorKey.currentState?.pushReplacementNamed('/config');
  } else {
    // If connection succeeds, go the login page
    await db.loadLocations();
    await db.loadBranches();
    await db.loadAccess();
    await Future.delayed(Duration(milliseconds: 200));
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}

void logout() {
  window.localStorage['Token'] = "";
  session = Session("");
  db.unloadMembers();

  tryConnect();
}

