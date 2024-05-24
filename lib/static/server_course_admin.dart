// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/requirement.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/message.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Course>> course_list(Session session, User? user, bool? active, bool? public) async {
  final response = await http.get(
    server.uri('/admin/course_list', {
      if (user != null) 'mod_id': user.id.toString(),
      if (active != null) 'active': active.toString(),
      if (public != null) 'public': public.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Course>.from(l.map((model) => Course.fromJson(model)));
}

Future<bool> course_create(Session session, Course course) async {
  final response = await http.post(
    server.uri('/admin/course_create'),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(course),
  );

  bool success = (response.statusCode == 200);
  messageSuccess(success);
  return success;
}

Future<bool> course_edit(Session session, Course course) async {
  final response = await http.post(
    server.uri('/admin/course_edit', {
      'course_id': course.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(course),
  );

  return (response.statusCode == 200);
}

Future<bool> course_delete(Session session, Course course) async {
  final response = await http.head(
    server.uri('/admin/course_delete', {'course_id': course.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> course_moderator_list(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/admin/course_moderator_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(list.map((model) => User.fromJson(model)));
}

Future<bool> course_moderator_add(Session session, int courseID, int userID) async {
  final response = await http.head(
    server.uri('/admin/course_moderator_add', {
      'course_id': courseID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> course_moderator_remove(Session session, int courseID, int userID) async {
  final response = await http.head(
    server.uri('/admin/course_moderator_remove', {
      'course_id': courseID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<Team>> course_owner_summon_list(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/admin/course_owner_summon_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<Team>.from(list.map((model) => Team.fromJson(model)));
}

Future<bool> course_owner_summon_add(Session session, int courseID, int teamID) async {
  final response = await http.head(
    server.uri('/admin/course_owner_summon_add', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> course_owner_summon_remove(Session session, int courseID, int teamID) async {
  final response = await http.head(
    server.uri('/admin/course_owner_summon_remove', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<Team>> course_owner_unsummon_list(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/admin/course_owner_unsummon_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<Team>.from(list.map((model) => Team.fromJson(model)));
}

Future<bool> course_owner_unsummon_add(Session session, int courseID, int teamID) async {
  final response = await http.head(
    server.uri('/admin/course_owner_unsummon_add', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> course_owner_unsummon_remove(Session session, int courseID, int teamID) async {
  final response = await http.head(
    server.uri('/admin/course_owner_unsummon_remove', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<Team>> course_participant_summon_list(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/admin/course_participant_summon_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<Team>.from(list.map((model) => Team.fromJson(model)));
}

Future<bool> course_participant_summon_add(Session session, int courseID, int teamID) async {
  final response = await http.head(
    server.uri('/admin/course_participant_summon_add', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> course_participant_summon_remove(Session session, int courseID, int teamID) async {
  final response = await http.head(
    server.uri('/admin/course_participant_summon_remove', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<Team>> course_participant_unsummon_list(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/admin/course_participant_unsummon_list', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<Team>.from(list.map((model) => Team.fromJson(model)));
}

Future<bool> course_participant_unsummon_add(Session session, int courseID, int teamID) async {
  final response = await http.head(
    server.uri('/admin/course_participant_unsummon_add', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> course_participant_unsummon_remove(Session session, int courseID, int teamID) async {
  final response = await http.head(
    server.uri('/admin/course_participant_unsummon_remove', {
      'course_id': courseID.toString(),
      'team_id': teamID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<Requirement>> course_requirement_list(Session session, Course course) async {
  final response = await http.get(
    server.uri('/admin/course_requirement_list', {
      'course_id': course.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Requirement>.from(l.map((model) => Requirement.fromJson(model)));
}

Future<bool> course_requirement_add(Session session, Requirement requirement) async {
  final response = await http.head(
    server.uri('/admin/course_requirement_add', {
      'course_id': requirement.course!.id.toString(),
      'skill_id': requirement.skill!.id.toString(),
      'rank': requirement.rank.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  bool success = (response.statusCode == 200);
  messageSuccess(success);
  return success;
}

Future<bool> course_requirement_remove(Session session, Requirement requirement) async {
  final response = await http.head(
    server.uri('/admin/course_requirement_remove', {
      'requirement_id': requirement.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  bool success = (response.statusCode == 200);
  messageSuccess(success);
  return success;
}

Future<List<(int, String, DateTime, DateTime, int, int)>> course_statistic_class(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/admin/course_statistic_class', {
      'course_id': courseID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(int, String, DateTime, DateTime, int, int)>.from(
    list.map((model) {
      return (
        model[0],
        model[1],
        parseNaiveDateTime(model[2])!.toLocal(),
        parseNaiveDateTime(model[3])!.toLocal(),
        model[4],
        model[5],
      );
    }),
  );
}

Future<List<(int, String, String, int)>> course_statistic_participant(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/admin/course_statistic_participant', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(int, String, String, int)>.from(
    list.map((model) {
      return (
        model[0],
        model[1],
        model[2],
        model[3],
      );
    }),
  );
}

Future<List<(int, String, DateTime, DateTime)>> course_statistic_participant1(
    Session session, int courseID, int participantID) async {
  final response = await http.get(
    server.uri('/admin/course_statistic_participant1', {
      'course_id': courseID.toString(),
      'participant_id': participantID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(int, String, DateTime, DateTime)>.from(
    list.map((model) {
      return (
        model[0],
        model[1],
        parseNaiveDateTime(model[2])!.toLocal(),
        parseNaiveDateTime(model[3])!.toLocal(),
      );
    }),
  );
}

Future<List<(int, String, String, int)>> course_statistic_owner(Session session, int courseID) async {
  final response = await http.get(
    server.uri('/admin/course_statistic_owner', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(int, String, String, int)>.from(
    list.map((model) {
      return (
        model[0],
        model[1],
        model[2],
        model[3],
      );
    }),
  );
}

Future<List<(int, String, DateTime, DateTime)>> course_statistic_owner1(
    Session session, int courseID, int ownerID) async {
  final response = await http.get(
    server.uri('/admin/course_statistic_owner1', {
      'course_id': courseID.toString(),
      'owner_id': ownerID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(int, String, DateTime, DateTime)>.from(
    list.map((model) {
      return (
        model[0],
        model[1],
        parseNaiveDateTime(model[2])!.toLocal(),
        parseNaiveDateTime(model[3])!.toLocal(),
      );
    }),
  );
}
