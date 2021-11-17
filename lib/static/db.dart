library db;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cptclient/static/navigation.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/branch.dart';
import 'package:cptclient/json/access.dart';

List<Location> cacheLocations = [];
List<Branch> cacheBranches = [];
List<Access> cacheAccess = [];

Future<bool> loadLocations() async {
  final response = await http.get(
    Uri.http(server, 'location_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return false;

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  cacheLocations = List<Location>.from(l.map((model) => Location.fromJson(model)));

  return true;
}

Future<bool> loadBranches() async {
  final response = await http.get(
    Uri.http(server, 'branch_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return false;

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  cacheBranches = List<Branch>.from(l.map((model) => Branch.fromJson(model)));

  return true;
}

Future<bool> loadAccess() async {
  final response = await http.get(
    Uri.http(server, 'access_list'),
    headers: {
      'Accept': 'application/json; charset=utf-8',
    },
  );

  if (response.statusCode != 200) return false;

  Iterable l = json.decode(utf8.decode(response.bodyBytes));
  cacheAccess = List<Access>.from(l.map((model) => Access.fromJson(model)));

  return true;
}