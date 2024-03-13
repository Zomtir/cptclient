// ignore_for_file: constant_identifier_names
// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/static/crypto.dart';
import 'package:intl/intl.dart';

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
        key = assembleSlotKey(),
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
        begin =
            DateFormat("yyyy-MM-ddTHH:mm").parse(json['begin'], true).toLocal(),
        end = DateFormat("yyyy-MM-ddTHH:mm").parse(json['end'], true).toLocal(),
        status = Status.values.firstWhere((x) => x.name == json['status']),
        public = json['public'],
        scrutable = json['scrutable'],
        note = json['note'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'title': title,
        'location': location?.toJson(),
        'begin': DateFormat("yyyy-MM-dd HH:mm").format(begin.toUtc()),
        'end': DateFormat("yyyy-MM-dd HH:mm").format(end.toUtc()),
        'status': status.toString(),
        'public': public,
        'scrutable': scrutable,
        'note': note,
      };

  Slot.fromCourse(Course course)
      : id = 0,
        key = assembleSlotKey(),
        title = course.title,
        location = null,
        begin = DateTime.now(),
        end = DateTime.now().add(Duration(hours: 1)),
        status = null,
        public = true,
        scrutable = false;

  Slot.fromUser(User user)
      : id = 0,
        key = assembleSlotKey(),
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

List<Slot> filterSlots(List<Slot> slots, DateTime dt) {
  DateTime earliest = dt.copyWith(hour: 0, minute: 0, second: 0);
  DateTime latest = dt.copyWith(hour: 24, minute: 0, second: 0);
  List<Slot> filtered = slots.where((Slot slot) {
    bool tooEarly = earliest.isAfter(slot.end);
    bool tooLate = latest.isBefore(slot.begin);

    return !(tooEarly || tooLate);
  }).toList();

  return filtered;
}