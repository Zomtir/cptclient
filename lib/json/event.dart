// ignore_for_file: constant_identifier_names
// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/crypto.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class Event extends FieldInterface implements Comparable {
  final int id;
  String key;
  String title;
  DateTime begin;
  DateTime end;
  Location? location;
  Occurrence? occurrence;
  Acceptance? acceptance;
  bool? public;
  bool? scrutable;
  String? note = "";

  Event({
    required this.id,
    required this.key,
    required this.title,
    required this.begin,
    required this.end,
    this.location,
    this.occurrence,
    required this.public,
    required this.scrutable,
    required this.note,
  });

  Event.fromEvent(Event event)
      : id = 0,
        key = assembleKey([3,3,3]),
        title = event.title,
        begin = event.begin,
        end = event.end,
        location = event.location,
        occurrence = event.occurrence,
        acceptance = event.acceptance,
        public = event.public,
        scrutable = event.scrutable;

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        title = json['title'],
        begin = parseIsoDateTime(json['begin'])!.toLocal(),
        end = parseIsoDateTime(json['end'])!.toLocal(),
        location = json['location'] == null ? null : Location.fromJson(json['location']),
        occurrence = Occurrence.fromNullString(json['occurrence']),
        acceptance = Acceptance.fromNullString(json['acceptance']),
        public = json['public'],
        scrutable = json['scrutable'],
        note = json['note'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'title': title,
        'begin': formatIsoDateTime(begin.toUtc()),
        'end': formatIsoDateTime(end.toUtc()),
        'location': location?.toJson(),
        'occurrence': occurrence?.name,
        'acceptance': acceptance?.name,
        'public': public,
        'scrutable': scrutable,
        'note': note,
      };

  Event.fromVoid()
      : id = 0,
        key = assembleKey([3,3,3]),
        title = 'Event ${DateTime.now()}',
        begin = DateTime.now(),
        end = DateTime.now().add(Duration(hours: 1)),
        location = null,
        occurrence = null,
        acceptance = Acceptance.draft,
        public = false,
        scrutable = false;

  Event.fromCourse(Course course)
      : id = 0,
        key = assembleKey([3,3,3]),
        title = course.title,
        begin = DateTime.now(),
        end = DateTime.now().add(Duration(hours: 1)),
        location = null,
        occurrence = null,
        acceptance = null,
        public = true,
        scrutable = true;

  Event.fromUser(User user)
      : id = 0,
        key = assembleKey([3,3,3]),
        title = "${user.key}'s individual reservation",
        begin = DateTime.now(),
        end = DateTime.now().add(Duration(hours: 1)),
        location = null,
        occurrence = null,
        acceptance = null,
        public = false,
        scrutable = true;

  @override
  int compareTo(other) {
    return begin.compareTo(other.begin);
  }

  @override
  get searchable {
    return [title, location?.name];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id] $key",
      child: Text("$title"),
    );
  }

  @override
  Widget buildInfo(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "[$id] $key", child: Icon(Icons.event)),
      trailing: trailing,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$title", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(compressDate(context, begin, end)),
            Text("${location!.name}", style: TextStyle(color: Colors.black54)),
            Text("${occurrence!.localizedName(context)}", textScaler: TextScaler.linear(1.3), style: TextStyle(color: Colors.black54)),
            Text("${acceptance!.localizedName(context)}", textScaler: TextScaler.linear(1.3), style: TextStyle(color: Colors.black54)),
          ]
      ),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "[$id] $key", child: Icon(Icons.event)),
      trailing: trailing,
      children: [
        Text("$title", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(compressDate(context, begin, end)),
        Text("${location!.name}", style: TextStyle(color: Colors.black54)),
        Text("${occurrence!.localizedName(context)}", textScaler: TextScaler.linear(1.3), style: TextStyle(color: Colors.black54)),
        Text("${acceptance!.localizedName(context)}", textScaler: TextScaler.linear(1.3), style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}

List<Event> filterEvents(List<Event> events, DateTime earliest, DateTime latest) {
  List<Event> filtered = events.where((Event event) {
    bool tooEarly = earliest.isAfter(event.end);
    bool tooLate = latest.isBefore(event.begin);

    if (event.occurrence == Occurrence.voided) return false;

    return !(tooEarly || tooLate);
  }).toList();

  filtered.sort();
  return filtered;
}
