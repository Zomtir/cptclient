// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cptclient/json/course.dart';
import 'package:cptclient/static/client.dart';

Future<List<Course>> course_list() async {
  final response = await client.get(
    uri('/anon/course_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return [];

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  return List<Course>.from(l.map((model) => Course.fromJson(model)));
}
