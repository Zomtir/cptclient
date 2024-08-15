// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/confirmation.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/message.dart';

Future<List<Event>> event_list(UserSession session,
    {DateTime? begin,
    DateTime? end,
    Location? location,
    Occurrence? occurrence,
    Acceptance? acceptance,
    bool? courseTrue,
    int? courseID}) async {
  final response = await client.get(
    uri('/regular/event_list', {
      'begin': formatWebDateTime(begin?.toUtc()),
      'end': formatWebDateTime(end?.toUtc()),
      'location_id': location?.id.toString(),
      'occurrence': occurrence?.name,
      'acceptance': acceptance?.name,
      'course_true': courseTrue?.toString(),
      'course_id': courseID?.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Event>.from(l.map((model) => Event.fromJson(model)));
}

Future<bool> event_create(UserSession session, Event event) async {
  if (event.key.isEmpty) return false;

  final response = await client.post(
    uri('/regular/event_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(event),
  );

  bool success = (response.statusCode == 200);
  messageSuccess(success);
  return success;
}

Future<bool?> event_owner_true(UserSession session, Event event) async {
  final response = await client.get(
    uri('/regular/event_owner_true', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes)) as bool;
}

Future<bool?> event_bookmark_true(UserSession session, Event event) async {
  final response = await client.get(
    uri('/regular/event_bookmark_true', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes)) as bool;
}

Future<bool> event_bookmark_edit(UserSession session, Event event, bool bookmark) async {
  final response = await client.head(
    uri('/regular/event_bookmark_edit', {
      'event_id': event.id.toString(),
      'bookmark': bookmark.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  return (response.statusCode != 200);
}

Future<Confirmation?> event_leader_registration_info(UserSession session, Event event) async {
  final response = await client.get(
    uri('/regular/event_leader_registration_info', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return Confirmation.fromNullString(utf8.decode(response.bodyBytes));
}

Future<bool> event_leader_registration_edit(UserSession session, Event event, Confirmation? confirmation) async {
  final response = await client.head(
    uri('/regular/event_leader_registration_edit', {
      'event_id': event.id.toString(),
      'status': confirmation?.name ?? 'NULL',
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  return (response.statusCode != 200);
}

Future<bool?> event_leader_presence_true(UserSession session, Event event) async {
  final response = await client.get(
    uri('/regular/event_leader_presence_true', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes)) as bool;
}

Future<bool> event_leader_presence_add(UserSession session, Event event) async {
  final response = await client.head(
    uri('/regular/event_leader_presence_add', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_leader_presence_remove(UserSession session, Event event) async {
  final response = await client.head(
    uri('/regular/event_leader_presence_remove', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<Confirmation?> event_supporter_registration_info(UserSession session, Event event) async {
  final response = await client.get(
    uri('/regular/event_supporter_registration_info', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return Confirmation.fromNullString(utf8.decode(response.bodyBytes));
}

Future<bool> event_supporter_registration_edit(UserSession session, Event event, Confirmation? confirmation) async {
  final response = await client.head(
    uri('/regular/event_supporter_registration_edit', {
      'event_id': event.id.toString(),
      'status': confirmation?.name ?? 'NULL',
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  return (response.statusCode != 200);
}

Future<bool?> event_supporter_presence_true(UserSession session, Event event) async {
  final response = await client.get(
    uri('/regular/event_supporter_presence_true', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes)) as bool;
}

Future<bool> event_supporter_presence_add(UserSession session, Event event) async {
  final response = await client.head(
    uri('/regular/event_supporter_presence_add', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_supporter_presence_remove(UserSession session, Event event) async {
  final response = await client.head(
    uri('/regular/event_supporter_presence_remove', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<Confirmation?> event_participant_registration_info(UserSession session, Event event) async {
  final response = await client.get(
    uri('/regular/event_participant_registration_info', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return Confirmation.fromNullString(utf8.decode(response.bodyBytes));
}

Future<bool> event_participant_registration_edit(UserSession session, Event event, Confirmation? confirmation) async {
  final response = await client.head(
    uri('/regular/event_participant_registration_edit', {
      'event_id': event.id.toString(),
      'status': confirmation?.name ?? 'NULL',
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  return (response.statusCode != 200);
}

Future<bool?> event_participant_presence_true(UserSession session, Event event) async {
  final response = await client.get(
    uri('/regular/event_participant_presence_true', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return null;

  return json.decode(utf8.decode(response.bodyBytes)) as bool;
}

Future<bool> event_participant_presence_add(UserSession session, Event event) async {
  final response = await client.head(
    uri('/regular/event_participant_presence_add', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_participant_presence_remove(UserSession session, Event event) async {
  final response = await client.head(
    uri('/regular/event_participant_presence_remove', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}