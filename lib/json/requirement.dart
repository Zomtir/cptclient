// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:flutter/material.dart';

class Requirement extends FieldInterface implements Comparable {
  final int id;
  Course? course;
  Skill? skill;
  int rank;

  Requirement(this.id, this.course, this.skill, this.rank);

  Requirement.create()
    : id = 0,
      course = null,
      skill = null,
      rank = 0;

  Requirement.fromCourse(Course this.course)
      : id = 0,
        skill = null,
        rank = 0;

  Requirement.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      course = Course.fromJson(json['course']),
      skill = Skill.fromJson(json['skill']),
      rank = json['rank'];

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'user': course?.toJson(),
      'skill': skill?.toJson(),
      'rank': rank,
    };

    Requirement.fromCompetence(Requirement competence)
      : id = 0,
        course = competence.course,
        skill = competence.skill,
        rank = competence.rank;

  @override
  bool operator ==(other) => other is Requirement && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    int criteria1 = course!.compareTo(other.course);
    if (criteria1 != 0) return criteria1;

    int criteria2 = skill!.compareTo(other.discipline);
    if (criteria2 != 0) return criteria2;

    int criteria3 = rank.compareTo(other.rank);
    return criteria3;
  }

  @override
  get searchable {
    return [course?.title, skill?.title, rank.toString()];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id]",
      child: Text("${course!.title} - ${skill!.title} - $rank"),
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
      leading: Tooltip(message: "$id", child: Icon(Icons.verified)),
      trailing: trailing,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${course!.title}", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${skill!.title} $rank"),
          ]
      ),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(message: "$id", child: Icon(Icons.verified)),
      trailing: trailing,
      children: [
        Text("${course!.title}", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("${skill!.title} $rank"),
      ],
    );
  }
}