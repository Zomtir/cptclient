// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'crypto.dart' as crypto;
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/json/right.dart';

Future<User?> user_info(String token) async {
  final response = await http.get(
    server.uri('/member/user_info'),
    headers: {
      'Token': token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<Right?> right_info(String token) async {
  final response = await http.get(
    server.uri('/member/user_right'),
    headers: {
      'Token': token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return null;

  return Right.fromJson(json.decode(utf8.decode(response.bodyBytes)));
}

Future<bool> password_edit(Session session, String password) async {
  final response = await http.post(
    server.uri('/member/user_password'),
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Token': session.token,
    },
    body: crypto.hashPassword(password, session.user!.key),
  );

  return (response.statusCode == 200);
}