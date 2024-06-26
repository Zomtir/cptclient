// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Event>> event_list(UserSession session,
    {DateTime? begin,
    DateTime? end,
    Location? location,
    Occurrence? occurrence,
    Acceptance? acceptance,
    bool? courseTrue,
    int? courseID,
    int? ownerID}) async {
  final response = await http.get(
    server.uri('/admin/event_list', {
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
  final response = await http.get(
    server.uri('/admin/event_info', {
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

Future<bool> event_create(UserSession session, int course_id, Event event) async {
  final response = await http.post(
    server.uri('/admin/event_create', {
      'course_id': course_id.toString(),
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
  final response = await http.post(
    server.uri('/admin/event_edit', {
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

  final response = await http.post(
    server.uri('/admin/event_password_edit', {
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

Future<bool> event_delete(UserSession session, Event event) async {
  final response = await http.head(
    server.uri('/admin/event_delete', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_accept(UserSession session, Event event) async {
  final response = await http.head(
    server.uri('/admin/event_accept', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_deny(UserSession session, Event event) async {
  final response = await http.head(
    server.uri('/admin/event_deny', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_suspend(UserSession session, Event event) async {
  final response = await http.head(
    server.uri('/admin/event_suspend', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_owner_pool(UserSession session, Event event) async {
  final response = await http.get(
    server.uri('/admin/event_owner_pool', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<User>> event_owner_list(UserSession session, Event event) async {
  final response = await http.get(
    server.uri('/admin/event_owner_list', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<bool> event_owner_add(UserSession session, Event event, User user) async {
  final response = await http.head(
    server.uri('/admin/event_owner_add', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_owner_remove(UserSession session, Event event, User user) async {
  final response = await http.head(
    server.uri('/admin/event_owner_remove', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_owner_registration_list(UserSession session, Event event) async {
  final response = await http.get(
    server.uri('/admin/event_owner_registration_list', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<User>> event_owner_invite_list(UserSession session, int eventID) async {
  final response = await http.get(
    server.uri('/admin/event_owner_invite_list', {
      'event_id': eventID.toString(),
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

Future<bool> event_owner_invite_add(UserSession session, int eventID, int userID) async {
  final response = await http.head(
    server.uri('/admin/event_owner_invite_add', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_owner_invite_remove(UserSession session, int eventID, int userID) async {
  final response = await http.head(
    server.uri('/admin/event_owner_invite_remove', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_owner_uninvite_list(UserSession session, int eventID) async {
  final response = await http.get(
    server.uri('/admin/event_owner_uninvite_list', {
      'event_id': eventID.toString(),
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

Future<bool> event_owner_uninvite_add(UserSession session, int eventID, int userID) async {
  final response = await http.head(
    server.uri('/admin/event_owner_uninvite_add', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_owner_uninvite_remove(UserSession session, int eventID, int userID) async {
  final response = await http.head(
    server.uri('/admin/event_owner_uninvite_remove', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_participant_presence_pool(UserSession session, Event event) async {
  final response = await http.get(
    server.uri('/admin/event_participant_presence_pool', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<User>> event_participant_presence_list(UserSession session, Event event) async {
  final response = await http.get(
    server.uri('/admin/event_participant_presence_list', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<bool> event_participant_presence_add(UserSession session, Event event, User user) async {
  final response = await http.head(
    server.uri('/admin/event_participant_presence_add', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_participant_presence_remove(UserSession session, Event event, User user) async {
  final response = await http.head(
    server.uri('/admin/event_participant_presence_remove', {
      'event_id': event.id.toString(),
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_participant_registration_list(UserSession session, Event event) async {
  final response = await http.get(
    server.uri('/admin/event_participant_registration_list', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((data) => User.fromJson(data)));
}

Future<List<User>> event_participant_invite_list(UserSession session, int eventID) async {
  final response = await http.get(
    server.uri('/admin/event_participant_invite_list', {
      'event_id': eventID.toString(),
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

Future<bool> event_participant_invite_add(UserSession session, int eventID, int userID) async {
  final response = await http.head(
    server.uri('/admin/event_participant_invite_add', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_participant_invite_remove(UserSession session, int eventID, int userID) async {
  final response = await http.head(
    server.uri('/admin/event_participant_invite_remove', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<User>> event_participant_uninvite_list(UserSession session, int eventID) async {
  final response = await http.get(
    server.uri('/admin/event_participant_uninvite_list', {
      'event_id': eventID.toString(),
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

Future<bool> event_participant_uninvite_add(UserSession session, int eventID, int userID) async {
  final response = await http.head(
    server.uri('/admin/event_participant_uninvite_add', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<bool> event_participant_uninvite_remove(UserSession session, int eventID, int userID) async {
  final response = await http.head(
    server.uri('/admin/event_participant_uninvite_remove', {
      'event_id': eventID.toString(),
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}

Future<List<(User, int, int, int)>> event_statistic_packlist(
    UserSession session, Event event, List<ItemCategory?> categories) async {
  final response = await http.get(
    server.uri('/admin/event_statistic_packlist', {
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
  final response = await http.get(
    server.uri('/admin/event_statistic_division', {
      'event_id': event.id.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(
    list.map((model) => User.fromJson(model)),
  );
}
