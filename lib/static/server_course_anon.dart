// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/course.dart';
import 'package:cptclient/static/server.dart';
import 'package:http/http.dart' as http;

Future<List<Course>> location_list() async {
  final response = await http.get(
    uri('/anon/course_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Course>.from(l.map((model) => Course.fromJson(model)));
}
