// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/requirement.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';

export 'leader.dart';
export 'moderator.dart';
export 'participant.dart';
export 'supporter.dart';

Future<List<Course>> course_list(UserSession session, User? user, bool? active, bool? public) async {
  final response = await client.get(
    uri('/admin/course_list', {
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

Future<bool> course_create(UserSession session, Course course) async {
  final response = await client.post(
    uri('/admin/course_create'),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(course),
  );

  bool success = (response.statusCode == 200);
  messageStatus(success);
  return success;
}

Future<bool> course_edit(UserSession session, Course course) async {
  final response = await client.post(
    uri('/admin/course_edit', {
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

Future<bool> course_delete(UserSession session, Course course) async {
  final response = await client.head(
    uri('/admin/course_delete', {'course_id': course.id.toString()}),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<Requirement>> course_requirement_list(UserSession session, Course course) async {
  final response = await client.get(
    uri('/admin/course_requirement_list', {
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

Future<bool> course_requirement_add(UserSession session, Requirement requirement) async {
  final response = await client.head(
    uri('/admin/course_requirement_add', {
      'course_id': requirement.course!.id.toString(),
      'skill_id': requirement.skill!.id.toString(),
      'rank': requirement.rank.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  bool success = (response.statusCode == 200);
  messageStatus(success);
  return success;
}

Future<bool> course_requirement_remove(UserSession session, Requirement requirement) async {
  final response = await client.head(
    uri('/admin/course_requirement_remove', {
      'requirement_id': requirement.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  bool success = (response.statusCode == 200);
  messageStatus(success);
  return success;
}

Future<int?> course_club_info(UserSession session, Course course) async {
  final response = await client.get(
    uri('/admin/course_club_info', {
      'course_id': course.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<bool> course_club_edit(UserSession session, Course course, Club? club) async {
  final response = await client.head(
    uri('/admin/course_club_edit', {
      'course_id': course.id.toString(),
      'club_id': club?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<(Event, int, int, int)>> course_statistic_class(UserSession session, int courseID) async {
  final response = await client.get(
    uri('/admin/course_statistic_class', {
      'course_id': courseID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(Event, int, int, int)>.from(
    list.map((model) {
      return (
        Event.fromJson(model[0]),
        model[1],
        model[2],
        model[3],
      );
    }),
  );
}

Future<List<(User, int)>> course_statistic_participant(UserSession session, int courseID) async {
  final response = await client.get(
    uri('/admin/course_statistic_participant', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(User, int)>.from(
    list.map((model) {
      return (
        User.fromJson(model[0]),
        model[1],
      );
    }),
  );
}

Future<List<Event>> course_statistic_participant1(
    UserSession session, int courseID, int participantID) async {
  final response = await client.get(
    uri('/admin/course_statistic_participant1', {
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
  return List<Event>.from(
    list.map((model) => Event.fromJson(model)),
  );
}

Future<List<(User, int)>> course_statistic_supporter(UserSession session, int courseID) async {
  final response = await client.get(
    uri('/admin/course_statistic_supporter', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(User, int)>.from(
    list.map((model) {
      return (
      User.fromJson(model[0]),
      model[1],
      );
    }),
  );
}

Future<List<Event>> course_statistic_supporter1(
    UserSession session, int courseID, int supporterID) async {
  final response = await client.get(
    uri('/admin/course_statistic_supporter1', {
      'course_id': courseID.toString(),
      'supporter_id': supporterID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<Event>.from(
    list.map((model) => Event.fromJson(model)),
  );
}

Future<List<(User, int)>> course_statistic_leader(UserSession session, int courseID) async {
  final response = await client.get(
    uri('/admin/course_statistic_leader', {'course_id': courseID.toString()}),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(User, int)>.from(
    list.map((model) {
      return (
      User.fromJson(model[0]),
      model[1],
      );
    }),
  );
}

Future<List<Event>> course_statistic_leader1(
    UserSession session, int courseID, int leaderID) async {
  final response = await client.get(
    uri('/admin/course_statistic_leader1', {
      'course_id': courseID.toString(),
      'leader_id': leaderID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<Event>.from(
    list.map((model) => Event.fromJson(model)),
  );
}
