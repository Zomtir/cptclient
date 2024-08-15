// ignore_for_file: constant_identifier_names
// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/crypto.dart';
import 'package:cptclient/utils/format.dart';

class Event implements Comparable {
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
        key = assembleKey([5]),
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
        begin = parseNaiveDateTime(json['begin'])!,
        end = parseNaiveDateTime(json['end'])!,
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
        'begin': formatNaiveDateTime(begin),
        'end': formatNaiveDateTime(end),
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
