// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<Event>>> event_list(UserSession session,
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
      'begin': formatWebDateTime(begin?.toUtc()),
      'end': formatWebDateTime(end?.toUtc()),
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

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Event>.from(it.map((model) => Event.fromJson(model)));
  return Success(list);
}

Future<Result<Event>> event_info(UserSession session, int eventID) async {
  final response = await client.get(
    uri('/admin/event_info', {
      'event_id': eventID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(Event.fromJson(json.decode(utf8.decode(response.bodyBytes))));
}

Future<Result<Credential>> event_credential(UserSession session, int eventID) async {
  final response = await client.get(
    uri('/admin/event_credential', {
      'event_id': eventID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var object = Credential.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  return Success(object);
}

Future<Result> event_create(UserSession session, Event event, int? courseID) async {
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

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> event_edit(UserSession session, Event event) async {
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

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> event_password_edit(UserSession session, Event event, String password) async {
  if (password.isEmpty) return Failure();

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

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<Course?>> event_course_info(UserSession session, Event event) async {
  final response = await client.get(
    uri('/admin/event_course_info', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();
  var model = json.decode(utf8.decode(response.bodyBytes));
  if (model == null) return Success(null);
  return Success(Course.fromJson(model));
}

Future<Result> event_course_edit(UserSession session, Event event, Course? course) async {
  final response = await client.head(
    uri('/admin/event_course_edit', {
      'event_id': event.id.toString(),
      'course_id': course?.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<()>> event_delete(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_delete', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> event_accept(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_accept', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> event_reject(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_reject', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> event_suspend(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_suspend', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<()>> event_withdraw(UserSession session, Event event) async {
  final response = await client.head(
    uri('/admin/event_withdraw', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result<List<(User, int, int, int)>>> event_statistic_packlist(
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

  if (handleFailedResponse(response)) return Failure();

  Iterable jlist = json.decode(utf8.decode(response.bodyBytes));
  var list = List<(User, int, int, int)>.from(
    jlist.map((model) {
      return (
        User.fromJson(model[0]),
        model[1],
        model[2],
        model[3],
      );
    }),
  );

  return Success(list);
}

Future<Result<List<Affiliation>>> event_statistic_organisation(UserSession session, Event event, Organisation organisation) async {
  final response = await client.get(
    uri('/admin/event_statistic_organisation', {
      'event_id': event.id.toString(),
      'organisation_id': organisation.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable jlist = json.decode(utf8.decode(response.bodyBytes));
  var list = List<Affiliation>.from(jlist.map((model) => Affiliation.fromJson(model)));
  return Success(list);
}
