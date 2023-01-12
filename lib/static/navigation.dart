library navigation;

import 'package:flutter/material.dart';

import "package:universal_html/html.dart"; // TODO go back to dart:html?

import 'package:cptclient/static/db.dart' as db;
import 'package:cptclient/static/serverUserMember.dart' as server;
import 'package:cptclient/static/serverSlotCasual.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';

String serverURL = window.localStorage['ServerURL']!;
Session? session;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();

void connect() async {
  if (await db.loadStatus()) {
    await loadCache();
    gotoRoute('/login');
  } else {
    gotoRoute('/config');
  }
}

void loginUser() async {
  if (await db.loadStatus()) {
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

  if (await db.loadStatus()) {
    await loadCache();
    gotoRoute('/login');
  } else {
    gotoRoute('/config');
  }
}

Future<bool> loadCache() async {
  // We are at the splash screen
  if (!await db.loadStatus()) {
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

  User? user = await server.user_info(window.localStorage['Token']!);
  if (user == null) return false;

  Right? right = await server.right_info(window.localStorage['Token']!);
  if (right == null) return false;

  session = Session(
    window.localStorage['Token']!,
    user: user,
    right: right,
  );

  db.loadMembers();
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

void refresh() {
  db.loadMembers();
  db.loadAccess();
  db.loadBranches();
  db.loadLocations();
}
