// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/crypto.dart' as crypto;

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

Future<bool> put_password(UserSession session, String password) async {
  if (password.isEmpty) return false;
  if (password.length < 6) return false;

  String salt = crypto.generateSaltHex();
  Credential credential = Credential(session.user!.key.toString(), crypto.hashPassword(password, salt), salt);

  final response = await client.post(
    uri('/regular/user_password'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(credential),
  );

  return (response.statusCode == 200);
}