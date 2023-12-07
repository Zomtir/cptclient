// ignore_for_file: constant_identifier_names
// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/static/crypto.dart';
import 'package:intl/intl.dart';

import 'location.dart';
import 'course.dart';
import 'user.dart';

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
  bool obscured;
  String note = "";

  Slot(this.id, this.key, this.title, this.location, this.begin, this.end, this.public, this.obscured, this.note);

  Slot.fromSlot(Slot slot)
      : id = 0,
        key = assembleSlotKey(),
        title = slot.title,
        location = slot.location,
        begin = slot.begin,
        end = slot.end,
        status = slot.status,
        public = slot.public,
        obscured = slot.obscured;

  Slot.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      key = json['key'],
      title = json['title'],
      location = Location.fromJson(json['location']),
      begin = DateFormat("yyyy-MM-dd HH:mm").parse(json['begin'], true).toLocal(),
      end = DateFormat("yyyy-MM-dd HH:mm").parse(json['end'], true).toLocal(),
      status = Status.values.firstWhere((x) => x.name == json['status']),
      public = json['public'],
      obscured = json['obscured'],
      note = json['note'];

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'key': key,
      'title': title,
      'location': location?.toJson(),
      'begin': DateFormat("yyyy-MM-dd HH:mm").format(begin.toUtc()),
      'end': DateFormat("yyyy-MM-dd HH:mm").format(end.toUtc()),
      'status': status.toString(),
      'public': public,
      'obscured' : obscured,
      'note' : note,
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
      obscured = false;

  Slot.fromUser(User user)
    : id = 0,
      key = assembleSlotKey(),
      title = "${user.key}'s individual reservation",
      location = null,
      begin = DateTime.now(),
      end = DateTime.now().add(Duration(hours: 1)),
      status = null,
      public = false,
      obscured = true;

  @override
  int compareTo(other) {
    return begin.compareTo(other.begin);
  }
}