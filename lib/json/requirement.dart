// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/skill.dart';

class Requirement {
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
}