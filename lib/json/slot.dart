import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import 'location.dart';
import 'course.dart';
import 'user.dart';

// ignore_for_file: non_constant_identifier_names

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
      : this.id = 0,
        this.key = "",
        this.title = slot.title,
        this.location = slot.location,
        this.begin = slot.begin,
        this.end = slot.end,
        this.status = slot.status,
        this.public = slot.public,
        this.obscured = slot.obscured;

  Slot.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      key = json['key'],
      title = json['title'],
      location = Location.fromJson(json['location']),
      begin = DateFormat("yyyy-MM-dd HH:mm").parse(json['begin'], true).toLocal(),
      end = DateFormat("yyyy-MM-dd HH:mm").parse(json['end'], true).toLocal(),
      status = Status.values.firstWhere((x) => describeEnum(x) == json['status']),
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
    : this.id = 0,
      this.key = "",
      this.title = course.title,
      this.location = null,
      this.begin = DateTime.now(),
      this.end = DateTime.now().add(Duration(hours: 1)),
      this.status = null,
      this.public = true,
      this.obscured = false;

  Slot.fromUser(User user)
    : this.id = 0,
      this.key = "",
      this.title = "${user.key}'s individual reservation",
      this.location = null,
      this.begin = DateTime.now(),
      this.end = DateTime.now().add(Duration(hours: 1)),
      this.status = null,
      this.public = false,
      this.obscured = true;

  @override
  int compareTo(other) {
    return this.begin.compareTo(other.begin);
  }
}