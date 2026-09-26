// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/crypto.dart' as crypto;
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';

Future<Result<List<User>>> user_list(UserSession session) async {
  final response = await client.get(
    uri('/admin/user_list'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  Iterable it = json.decode(utf8.decode(response.bodyBytes));
  var list = List<User>.from(it.map((model) => User.fromJson(model)));
  return Success(list);
}

Future<Result<User>> user_detailed(UserSession session, int userID) async {
  final response = await client.get(
    uri('/admin/user_detailed', {
      'user_id': userID.toString(),
    }),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (handleFailedResponse(response)) return Failure();

  var object = User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  return Success(object);
}

Future<Result<Credential>> user_password_info(UserSession session, int userID) async {
  final response = await client.get(
    uri('/admin/user_password_info', {
      'user_id': userID.toString(),
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

Future<Result> user_create(UserSession session, User user) async {
  final response = await client.post(
    uri('/admin/user_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(user),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> user_edit(UserSession session, User user) async {
  final response = await client.post(
    uri('/admin/user_edit', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(user),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> user_delete(UserSession session, User user) async {
  final response = await client.head(
    uri('/admin/user_delete', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> user_password_create(UserSession session, User user, String password, String salt) async {
  Credential credential = Credential(login: user.key.toString(), password: crypto.hashPassword(password, salt), salt: salt);

  final response = await client.post(
    uri('/admin/user_password_create', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(credential),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> user_password_edit(UserSession session, User user, String password, String salt) async {
  Credential credential = Credential(login: user.key.toString(), password: crypto.hashPassword(password, salt), salt: salt);

  final response = await client.post(
    uri('/admin/user_password_edit', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(credential),
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}

Future<Result> user_password_delete(UserSession session, User user) async {
  final response = await client.head(
    uri('/admin/user_password_delete', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  if (handleFailedResponse(response)) return Failure();
  return Success(());
}
