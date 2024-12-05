import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/license.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/message.dart';

Future<bool> user_license_main_create(UserSession session, User user, License license) async {
  final response = await client.post(
    uri('/admin/user_license_main_create', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(license),
  );

  bool success = response.statusCode == 200;
  messageFailureOnly(success);
  return (success);
}

Future<bool> user_license_main_edit(UserSession session, User user, License license) async {
  final response = await client.post(
    uri('/admin/user_license_main_edit', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(license),
  );

  bool success = response.statusCode == 200;
  messageFailureOnly(success);
  return (success);
}

Future<bool> user_license_main_delete(UserSession session, User user) async {
  final response = await client.head(
    uri('/admin/user_license_main_delete', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  bool success = response.statusCode == 200;
  messageFailureOnly(success);
  return (success);
}

Future<bool> user_license_extra_create(UserSession session, User user, License license) async {
  final response = await client.post(
    uri('/admin/user_license_extra_create', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(license),
  );

  bool success = response.statusCode == 200;
  messageFailureOnly(success);
  return (success);
}

Future<bool> user_license_extra_edit(UserSession session, User user, License license) async {
  final response = await client.post(
    uri('/admin/user_license_extra_edit', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(license),
  );

  bool success = response.statusCode == 200;
  messageFailureOnly(success);
  return (success);
}

Future<bool> user_license_extra_delete(UserSession session, User user) async {
  final response = await client.head(
    uri('/admin/user_license_extra_delete', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  bool success = response.statusCode == 200;
  messageFailureOnly(success);
  return (success);
}