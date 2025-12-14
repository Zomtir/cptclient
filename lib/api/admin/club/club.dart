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
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Club>>> club_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/club_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Club>.from(it.map((model) => Club.fromJson(model)));
  return Success(list);
}

Future<Result<Club>> club_info(UserSession session, int clubID) async {
  final response = await client.get(
    uri('/admin/club_info', {
      'club_id': clubID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var club_info = Club.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  return Success(club_info);
}

Future<Result> club_create(UserSession session, Club club) async {
  final response = await client.post(
    uri('/admin/club_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(club),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> club_edit(UserSession session, Club club) async {
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

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> club_delete(UserSession session, int clubID) async {
  final response = await client.head(
    uri('/admin/club_delete', {
      'club_id': clubID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<List<(User, int)>>> club_statistic_members(UserSession session, Club club, DateTime point_in_time) async {
  final response = await client.get(
    uri('/admin/club_statistic_members', {
      'club_id': club.id.toString(),
      'point_in_time': formatWebDate(point_in_time.toUtc()),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<(User, int)>.from(it.map((model) => (User.fromJson(model[0]), model[1])));
  return Success(list);
}

Future<Result<List<User>>> club_statistic_team(
  UserSession session,
  Club club,
  DateTime point_in_time,
  Team team,
) async {
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

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<User>.from(it.map((model) => User.fromJson(model)));
  return Success(list);
}

Future<Result<List<Affiliation>>> club_statistic_organisation(
  UserSession session,
  Club club,
  Organisation organisation,
  DateTime point_in_time,
) async {
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

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Affiliation>.from(it.map((model) => Affiliation.fromJson(model)));
  return Success(list);
}

Future<Result<List<Event>>> club_statistic_presence(
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

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Event>.from(it.map((model) => Event.fromJson(model)));
  return Success(list);
}
