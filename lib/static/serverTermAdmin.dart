// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/json/user.dart';

Future<List<Term>> term_list(Session session) async {
  final response = await http.get(
    server.uri('/admin/term_list'),
    headers: {
      'Token': session.token,
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Term>.from(l.map((model) => Term.fromJson(model)));
}

Future<bool> term_create(Session session, Term term) async {
  final response = await http.post(
    server.uri('/admin/term_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(term),
  );

  return (response.statusCode == 200);
}

Future<bool> term_edit(Session session, Term term) async {
  final response = await http.post(
    server.uri('/admin/term_edit', {
      'term_id': term.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(term),
  );

  return (response.statusCode == 200);
}

Future<bool> term_delete(Session session, Term term) async {
  final response = await http.head(
    server.uri('/admin/term_delete', {
      'term_id': term.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
