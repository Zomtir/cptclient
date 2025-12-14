// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/confirmation.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/valence.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Event>>> event_list(
  UserSession session, {
  DateTime? begin,
  DateTime? end,
  Location? location,
  Occurrence? occurrence,
  Acceptance? acceptance,
  bool? courseTrue,
  int? courseID,
}) async {
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

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Event>.from(it.map((model) => Event.fromJson(model)));
  return Success(list);
}

Future<Result<()>> event_create(UserSession session, Event event) async {
  if (event.key.isEmpty) return Failure();

  final response = await client.post(
    uri('/regular/event_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(event),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<bool>> event_owner_true(UserSession session, int eventID) async {
  final response = await client.get(
    uri('/regular/event_owner_true', {
      'event_id': eventID.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  return Success(json.decode(utf8.decode(response.bodyBytes)) as bool);
}

Future<Result<bool>> event_moderator_true(UserSession session, int eventID) async {
  final response = await client.get(
    uri('/regular/event_moderator_true', {
      'event_id': eventID.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  bool isTrue = json.decode(utf8.decode(response.bodyBytes)) as bool;
  return Success(isTrue);
}

Future<Result<bool>> event_bookmark_true(UserSession session, int eventID) async {
  final response = await client.get(
    uri('/regular/event_bookmark_true', {
      'event_id': eventID.toString(),
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  bool isTrue = json.decode(utf8.decode(response.bodyBytes)) as bool;
  return Success(isTrue);
}

Future<Result> event_bookmark_edit(UserSession session, Event event, bool bookmark) async {
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

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<Confirmation?>> event_attendance_registration_info(UserSession session, int eventID, String role) async {
  final response = await client.get(
    uri('/regular/event_attendance_registration_info', {
      'event_id': eventID.toString(),
      'role': role,
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var confirmation = Confirmation.fromNullString(utf8.decode(response.bodyBytes));
  return Success(confirmation);
}

Future<bool> event_attendance_registration_edit(
  UserSession session,
  int eventID,
  String role,
  Confirmation? confirmation,
) async {
  final response = await client.head(
    uri('/regular/event_attendance_registration_edit', {
      'event_id': eventID.toString(),
      'role': role,
      'status': confirmation?.name ?? 'NULL',
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  return (response.statusCode != 200);
}

Future<Result<Valence?>> event_attendance_presence_true(UserSession session, int eventID, String role) async {
  final response = await client.get(
    uri('/regular/event_attendance_presence_true', {
      'event_id': eventID.toString(),
      'role': role,
    }),
    headers: {
      'Accept': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();

  bool isTrue = json.decode(utf8.decode(response.bodyBytes)) as bool;
  return Success(Valence.fromBool(isTrue));
}

Future<Result> event_attendance_presence_add(UserSession session, Event event, String role) async {
  final response = await client.head(
    uri('/regular/event_attendance_presence_add', {
      'event_id': event.id.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> event_attendance_presence_remove(UserSession session, Event event, String role) async {
  final response = await client.head(
    uri('/regular/event_attendance_presence_remove', {
      'event_id': event.id.toString(),
      'role': role,
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
