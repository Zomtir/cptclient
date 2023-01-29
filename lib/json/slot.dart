import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import 'location.dart';
import 'course.dart';
import 'user.dart';

// ignore_for_file: non_constant_identifier_names

enum Status { DRAFT, PENDING, OCCURRING, REJECTED, CANCELED }

class Slot {
  final int id;
  String key;
  String title;
  Location? location;
  DateTime begin;
  DateTime end;
  Status? status;
  bool autologin = false;
  int? course_id;
  List<User>? owners;
  //final String description;

  Slot(this.id, this.key, this.title, this.location, this.begin, this.end, {this.course_id, this.owners});

  Slot.fromSlot(Slot slot)
      : this.id = 0,
        this.key = "",
        this.title = slot.title,
        this.location = slot.location,
        this.begin = slot.begin,
        this.end = slot.end,
        this.status = slot.status,
        this.course_id = slot.course_id,
        this.owners = slot.owners;

  Slot.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      key = json['key'],
      title = json['title'],
      location = Location.fromJson(json['location']),
      begin = DateFormat("yyyy-MM-dd HH:mm").parse(json['begin'], true).toLocal(),
      end = DateFormat("yyyy-MM-dd HH:mm").parse(json['end'], true).toLocal(),
      status = Status.values.firstWhere((x) => describeEnum(x) == json['status']),
      course_id = json['course_id'],
      owners = json['user_id']?.map((data) => User.fromJson(data)).toList();

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'key': key,
      'title': title,
      'location': location?.toJson(),
      'begin': DateFormat("yyyy-MM-dd HH:mm").format(begin.toUtc()),
      'end': DateFormat("yyyy-MM-dd HH:mm").format(end.toUtc()),
      'status': status.toString(),
      'course_id': course_id
    };

  Slot.fromCourse(Course course)
    : this.id = 0,
      this.key = "",
      this.title = course.title,
      this.location = null,
      this.begin = DateTime.now(),
      this.end = DateTime.now().add(Duration(hours: 1)),
      this.status = null,
      this.course_id = course.id,
      this.owners = null;

  Slot.fromUser(User user)
    : this.id = 0,
      this.key = "",
      this.title = "${user.key}'s individual reservation",
      this.location = null,
      this.begin = DateTime.now(),
      this.end = DateTime.now().add(Duration(hours: 1)),
      this.status = null,
      this.course_id = null,
      this.owners = [user];

  // TODO The user ID is not picked up server side anyway,
  // but should be eventually if an admin should be able to create user reservations
}