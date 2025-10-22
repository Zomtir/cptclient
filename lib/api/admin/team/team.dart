// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<List<Team>?> team_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/team_list'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Team>.from(l.map((model) => Team.fromJson(model)));
}

Future<Team?> team_info(UserSession session, int teamID) async {
  final response = await client.get(
    uri('/admin/team_info', {
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Team.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<Result<int>> team_create(UserSession session, Team team) async {
  final response = await client.post(
    uri('/admin/team_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(team),
  );

  if (handleFailedResponse(response)) return Failure();

  int? id = int.tryParse(utf8.decode(response.bodyBytes));
  if (id == null) return Failure();

  return Success(id);
}

Future<Result> team_edit(UserSession session, Team team) async {
  final response = await client.post(
    uri('/admin/team_edit', {
      'team_id': team.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(team),
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(());
}

Future<bool> team_right_edit(UserSession session, Team team) async {
  final response = await client.post(
    uri('/admin/team_right_edit', {
      'team_id': team.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(team.right),
  );

  return (response.statusCode == 200);
}

Future<bool> team_delete(UserSession session, Team team) async {
  final response = await client.head(
    uri('/admin/team_delete', {
      'team_id': team.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> team_member_list(UserSession session, int teamID) async {
  final response = await client.get(
    uri('/admin/team_member_list', {'team_id': teamID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(list.map((model) => User.fromJson(model)));
}

Future<bool> team_member_add(UserSession session, int teamID, int userID) async {
  final response = await client.head(
    uri('/admin/team_member_add', {
      'team_id': teamID.toString(),
      'user_id' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> team_member_remove(UserSession session, int teamID, int userID) async {
  final response = await client.head(
    uri('/admin/team_member_remove', {
      'team_id': teamID.toString(),
      'user_id' : userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}