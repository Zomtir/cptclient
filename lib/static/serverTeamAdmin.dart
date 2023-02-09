// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';

Future<List<Team>> team_list(Session session) async {
  final response = await http.get(
    server.uri('/admin/team_list'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Team>.from(l.map((model) => Team.fromJson(model)));
}

Future<bool> team_create(Session session, Team team) async {
  final response = await http.post(
    server.uri('/admin/team_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(team),
  );

  return (response.statusCode == 200);
}

Future<bool> team_edit(Session session, Team team) async {
  final response = await http.post(
    server.uri('/admin/team_edit', {
      'team_id': team.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(team),
  );

  return (response.statusCode == 200);
}

Future<bool> team_delete(Session session, Team team) async {
  final response = await http.head(
    server.uri('team_delete', {
      'team_id': team.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> team_member_list(Session session, int teamID) async {
  final response = await http.get(
    server.uri('/admin/team_member_list', {'team_id': teamID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(list.map((model) => User.fromJson(model)));
}

Future<bool> team_member_add(Session session, int teamID, int userID) async {
  final response = await http.head(
    server.uri('/admin/team_member_add', {
      'team_id': teamID.toString(),
      'user_id' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> team_member_remove(Session session, int teamID, int userID) async {
  final response = await http.head(
    server.uri('/admin/team_member_remove', {
      'team_id': teamID.toString(),
      'user_id' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}