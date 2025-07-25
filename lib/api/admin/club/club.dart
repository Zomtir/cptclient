// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/format.dart';

Future<List<Club>> club_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/club_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Club>.from(l.map((model) => Club.fromJson(model)));
}

Future<Club?> club_info(UserSession session, Club club) async {
  final response = await client.get(
    uri('/admin/club_info', {
      'club_id': club.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  var content = json.decode(utf8.decode(response.bodyBytes));
  return Club.fromJson(content);
}

Future<bool> club_create(UserSession session, Club club) async {
  final response = await client.post(
    uri('/admin/club_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(club),
  );

  return (response.statusCode == 200);
}

Future<bool> club_edit(UserSession session, Club club) async {
  final response = await client.post(
    uri('/admin/club_edit', {
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

Future<bool> club_delete(UserSession session, Club club) async {
  final response = await client.head(
    uri('/admin/club_delete', {
      'club_id': club.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<(User, int)>> club_statistic_members(UserSession session, Club club, DateTime point_in_time) async {
  final response = await client.get(
    uri('/admin/club_statistic_members', {
      'club_id': club.id.toString(),
      'point_in_time': formatWebDate(point_in_time.toUtc()),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<(User, int)>.from(l.map((model) => (User.fromJson(model[0]), model[1])));
}

Future<List<User>> club_statistic_team(UserSession session, Club club, DateTime point_in_time, Team team) async {
  final response = await client.get(
    uri('/admin/club_statistic_team', {
      'club_id': club.id.toString(),
      'point_in_time': formatWebDate(point_in_time.toUtc()),
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

Future<List<Affiliation>?> club_statistic_organisation(
    UserSession session, Club club, Organisation organisation, DateTime point_in_time) async {
  final response = await client.get(
    uri('/admin/club_statistic_organisation', {
      'club_id': club.id.toString(),
      'organisation_id': organisation.id.toString(),
      'point_in_time': formatWebDate(point_in_time.toUtc()),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Affiliation>.from(l.map((model) => Affiliation.fromJson(model)));
}

Future<List<Event>?> club_statistic_presence(
  UserSession session,
  int clubID,
  int userID,
  DateTime time_window_begin,
  DateTime time_window_end,
  String role,
) async {
  final response = await client.get(
    uri('/admin/club_statistic_attendance', {
      'club_id': clubID.toString(),
      'user_id': userID.toString(),
      'role': role,
      'time_window_begin': formatWebDateTime(time_window_begin.toUtc()),
      'time_window_end': formatWebDateTime(time_window_end.toUtc()),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<Event>.from(
    list.map((model) => Event.fromJson(model)),
  );
}
