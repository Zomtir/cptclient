// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:http/http.dart' as http;

Future<List<Club>> club_list(Session session) async {
  final response = await http.get(
    server.uri('/admin/club_list'),
    headers: {
      'Token': session.token,
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Club>.from(l.map((model) => Club.fromJson(model)));
}

Future<bool> club_create(Session session, Club club) async {
  final response = await http.post(
    server.uri('/admin/club_create'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(club),
  );

  return (response.statusCode == 200);
}

Future<bool> club_edit(Session session, Club club) async {
  final response = await http.post(
    server.uri('/admin/club_edit', {
      'club_id': club.id.toString(),
    }),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': session.token,
    },
    body: json.encode(club),
  );

  return (response.statusCode == 200);
}

Future<bool> club_delete(Session session, Club club) async {
  final response = await http.head(
    server.uri('/admin/club_delete', {
      'club_id': club.id.toString(),
    }),
    headers: {
      'Token': session.token,
    },
  );

  return (response.statusCode == 200);
}
