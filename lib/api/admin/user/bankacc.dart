import 'dart:convert';

import 'package:cptclient/core/client.dart';
import 'package:cptclient/json/bankacc.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';

Future<bool> user_bank_account_create(UserSession session, User user, BankAccount bankacc) async {
  final response = await client.post(
    uri('/admin/user_bank_account_create', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(bankacc),
  );

  bool success = response.statusCode == 200;
  return success;
}

Future<bool> user_bank_account_edit(UserSession session, User user, BankAccount bankacc) async {
  final response = await client.post(
    uri('/admin/user_bank_account_edit', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(bankacc),
  );

  bool success = response.statusCode == 200;
  return (success);
}

Future<bool> user_bank_account_delete(UserSession session, User user) async {
  final response = await client.head(
    uri('/admin/user_bank_account_delete', {
      'user_id': user.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  bool success = response.statusCode == 200;
  return (success);
}
