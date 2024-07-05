// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/client.dart';
import 'package:cptclient/static/format.dart';

export 'leader.dart';
export 'owner.dart';
export 'participant.dart';
export 'supporter.dart';

Future<List<Event>> event_list(UserSession session,
    {DateTime? begin,
    DateTime? end,
    Location? location,
    Occurrence? occurrence,
    Acceptance? acceptance,
    bool? courseTrue,
    int? courseID,
    int? ownerID}) async {
  final response = await client.get(
    uri('/admin/event_list', {
      'begin': formatWebDateTime(begin),
      'end': formatWebDateTime(end),
      'location_id': location?.id.toString(),
      'occurrence': occurrence?.name,
      'acceptance': acceptance?.name,
      'course_true': courseTrue?.toString(),
      'course_id': courseID?.toString(),
      'owner_id': ownerID?.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Event>.from(l.map((model) => Event.fromJson(model)));
}

Future<Event?> event_info(UserSession session, int eventID) async {
  final response = await client.get(
    uri('/admin/event_info', {
      'event_id': eventID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Event.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<Credential?> event_credential(UserSession session, int eventID) async {
  final response = await client.get(
    uri('/admin/event_credential', {
      'event_id': eventID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Credential.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<bool> event_create(UserSession session, Event event, int? courseID) async {
  final response = await client.post(
    uri('/admin/event_create', {
      'course_id': courseID?.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(event),
  );

  return (response.statusCode == 200);
}

Future<bool> event_edit(UserSession session, Event event) async {
  final response = await client.post(
    uri('/admin/event_edit', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(event),
  );

  return (response.statusCode == 200);
}

Future<bool> event_password_edit(UserSession session, Event event, String password) async {
  if (password.isEmpty) return true;

  final response = await client.post(
    uri('/admin/event_password_edit', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Token': session.token,
    },
    body: utf8.encode(password),
  );

  return (response.statusCode == 200);
}

Future<int?> event_course_info(UserSession session, Event event) async {
  final response = await client.get(
    uri('/admin/event_course_info', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<bool> event_course_edit(UserSession session, Event event, Course? course) async {
  final response = await client.head(
    uri('/admin/event_course_edit', {
      'event_id': event.id.toString(),
      'course_id': course?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_delete(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_delete', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_accept(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_accept', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_reject(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_reject', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_suspend(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_suspend', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_withdraw(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_withdraw', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<(User, int, int, int)>> event_statistic_packlist(
    UserSession session, Event event, List<ItemCategory?> categories) async {
  final response = await client.get(
    uri('/admin/event_statistic_packlist', {
      'event_id': event.id.toString(),
      'category1': categories[0]?.id.toString(),
      'category2': categories[1]?.id.toString(),
      'category3': categories[2]?.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<(User, int, int, int)>.from(
    list.map((model) {
      return (
        User.fromJson(model[0]),
        model[1],
        model[2],
        model[3],
      );
    }),
  );
}

Future<List<User>> event_statistic_division(UserSession session, Event event) async {
  final response = await client.get(
    uri('/admin/event_statistic_division', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(list.map((model) => User.fromJson(model)));
}

Future<List<User>> event_statistic_organisation(UserSession session, Event event) async {
  final response = await client.get(
    uri('/admin/event_statistic_organisation', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(list.map((model) => User.fromJson(model)));
}
