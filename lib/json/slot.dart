// ignore_for_file: constant_identifier_names
// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/crypto.dart';
import 'package:cptclient/static/format.dart';

enum Status { DRAFT, PENDING, OCCURRING, REJECTED, CANCELED }

class Slot implements Comparable {
  final int id;
  String key;
  String title;
  Location? location;
  DateTime begin;
  DateTime end;
  Status? status;
  bool public;
  bool scrutable;
  String note = "";

  Slot({
    required this.id,
    required this.key,
    required this.title,
    this.location,
    required this.begin,
    required this.end,
    required this.public,
    required this.scrutable,
    required this.note,
  });

  Slot.fromSlot(Slot slot)
      : id = 0,
        key = assembleKey([5]),
        title = slot.title,
        location = slot.location,
        begin = slot.begin,
        end = slot.end,
        status = slot.status,
        public = slot.public,
        scrutable = slot.scrutable;

  Slot.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        title = json['title'],
        location = Location.fromJson(json['location']),
        begin = parseNaiveDateTime(json['begin'])!,
        end = parseNaiveDateTime(json['end'])!,
        status = Status.values.firstWhere((x) => x.name == json['status']),
        public = json['public'],
        scrutable = json['scrutable'],
        note = json['note'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'title': title,
        'location': location?.toJson(),
        'begin': formatNaiveDateTime(begin),
        'end': formatNaiveDateTime(end),
        'status': status.toString(),
        'public': public,
        'scrutable': scrutable,
        'note': note,
      };

  Slot.fromCourse(Course course)
      : id = 0,
        key = assembleKey([3,3,3]),
        title = course.title,
        location = null,
        begin = DateTime.now(),
        end = DateTime.now().add(Duration(hours: 1)),
        status = null,
        public = true,
        scrutable = false;

  Slot.fromUser(User user)
      : id = 0,
        key = assembleKey([3,3,3]),
        title = "${user.key}'s individual reservation",
        location = null,
        begin = DateTime.now(),
        end = DateTime.now().add(Duration(hours: 1)),
        status = null,
        public = false,
        scrutable = true;

  @override
  int compareTo(other) {
    return begin.compareTo(other.begin);
  }
}

List<Slot> filterSlots(List<Slot> slots, DateTime earliest, DateTime latest) {
  List<Slot> filtered = slots.where((Slot slot) {
    bool tooEarly = earliest.isAfter(slot.end);
    bool tooLate = latest.isBefore(slot.begin);

    return !(tooEarly || tooLate);
  }).toList();

  filtered.sort();
  return filtered;
}
