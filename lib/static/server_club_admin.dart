// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Club>> club_list(Session session) async {
  final response = await http.get(
    server.uri('/admin/club_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Club>.from(l.map((model) => Club.fromJson(model)));
}

Future<bool> club_create(Session session, Club club) async {
  final response = await http.post(
    server.uri('/admin/club_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(club),
  );

  return (response.statusCode == 200);
}

Future<bool> club_edit(Session session, Club club) async {
  final response = await http.post(
    server.uri('/admin/club_edit', {
      'club_id': club.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(club),
  );

  return (response.statusCode == 200);
}

Future<bool> club_delete(Session session, Club club) async {
  final response = await http.head(
    server.uri('/admin/club_delete', {
      'club_id': club.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<(User, int)>> club_statistic_members(Session session, Club club, DateTime point_in_time) async {
  final response = await http.get(
    server.uri('/admin/club_statistic_members', {
      'club_id': club.id.toString(),
      'point_in_time': formatWebDate(point_in_time),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<(User, int)>.from(l.map((model) => (User.fromJson(model[0]), model[1])));
}

Future<List<User>> club_statistic_team(Session session, Club club, DateTime point_in_time, Team team) async {
  final response = await http.get(
    server.uri('/admin/club_statistic_team', {
      'club_id': club.id.toString(),
      'point_in_time': formatWebDate(point_in_time),
      'team_id': team.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(l.map((model) => User.fromJson(model)));
}