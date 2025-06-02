// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/crypto.dart' as crypto;
import 'package:cptclient/utils/result.dart';

Future<List<User>> user_list(UserSession session) async {
  final response = await client.get(
    uri('/regular/user_list'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable list = json.decode(utf8.decode(response.bodyBytes));
  return List<User>.from(list.map((model) => User.fromJson(model)));
}

Future<User?> user_info(UserSession session) async {
  final response = await client.get(
    uri('/regular/user_info'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<Right?> right_info(UserSession session) async {
  final response = await client.get(
    uri('/regular/user_right'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Right.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<Result<Credential>> user_password_info(UserSession session) async {
  final response = await client.get(
    uri('/regular/user_password_info'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return Failure();

  return Success(Credential.fromJson(json.decode(utf8.decode(response.bodyBytes))));
}

Future<bool> user_password_edit(UserSession session, String password, String salt) async {
  if (password.length < 6 || password.length > 50) return false;

  Credential credential = Credential(login: session.user!.key.toString(), password: crypto.hashPassword(password, salt), salt: salt);

  final response = await client.post(
    uri('/regular/user_password_edit'),
    headers: {
      'Token': session.token,
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: json.encode(credential),
  );

  return (response.statusCode == 200);
}
