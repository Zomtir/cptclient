// ignore_for_file: non_constant_identifier_names
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Permission {
  final String id;
  final String name;
  final bool read;
  final bool write;

  const Permission(this.id, this.name, {this.read = false, this.write = false});

  Permission copyWith({bool? read, bool? write}) => Permission(
        id,
        name,
        read: read ?? this.read,
        write: write ?? this.write,
      );
}

class Right {
  Permission club;
  Permission competence;
  Permission course;
  Permission event;
  Permission inventory;
  Permission location;
  Permission organisation;
  Permission team;
  Permission user;

  Right({
    this.club = const Permission("club", "Club", read: false, write: false),
    this.competence = const Permission("competence", "Competence", read: false, write: false),
    this.course = const Permission("course", "Course", read: false, write: false),
    this.event = const Permission("event", "Event", read: false, write: false),
    this.inventory = const Permission("inventory", "Inventory", read: false, write: false),
    this.location = const Permission("location", "Location", read: false, write: false),
    this.organisation = const Permission("organisation", "Organisation", read: false, write: false),
    this.team = const Permission("team", "Team", read: false, write: false),
    this.user = const Permission("user", "User", read: false, write: false),
  });

  Right.fromRight(Right right)
      : club = right.club,
        competence = right.competence,
        course = right.course,
        event = right.event,
        inventory = right.inventory,
        location = right.location,
        organisation = right.organisation,
        team = right.team,
        user = right.user;

  Right.fromJson(Map<String, dynamic> json)
      : club = Permission(
          "club",
          "Club",
          read: json['right_club_read'],
          write: json['right_club_write'],
        ),
        competence = Permission(
          "competence",
          "Competence",
          read: json['right_competence_read'],
          write: json['right_competence_write'],
        ),
        course = Permission(
          "course",
          "Course",
          read: json['right_course_read'],
          write: json['right_course_write'],
        ),
        event = Permission(
          "event",
          "Event",
          read: json['right_event_read'],
          write: json['right_event_write'],
        ),
        inventory = Permission(
          "inventory",
          "Inventory",
          read: json['right_inventory_read'],
          write: json['right_inventory_write'],
        ),
        location = Permission(
          "location",
          "Location",
          read: json['right_location_read'],
          write: json['right_location_write'],
        ),
        organisation = Permission(
          "organisation",
          "Organisation",
          read: json['right_organisation_read'],
          write: json['right_organisation_write'],
        ),
        team = Permission(
          "team",
          "Team",
          read: json['right_team_read'],
          write: json['right_team_write'],
        ),
        user = Permission(
          "user",
          "User",
          read: json['right_user_read'],
          write: json['right_user_write'],
        );

  Map<String, dynamic> toJson() => {
        'right_club_write': club.write,
        'right_club_read': club.read,
        'right_competence_write': competence.write,
        'right_competence_read': competence.read,
        'right_course_write': course.write,
        'right_course_read': course.read,
        'right_event_write': event.write,
        'right_event_read': event.read,
        'right_inventory_write': inventory.write,
        'right_inventory_read': inventory.read,
        'right_location_write': location.write,
        'right_location_read': location.read,
        'right_organisation_write': organisation.write,
        'right_organisation_read': organisation.read,
        'right_team_write': team.write,
        'right_team_read': team.read,
        'right_user_write': user.write,
        'right_user_read': user.read,
      };

  List<Permission> toList() => [
        club,
        competence,
        course,
        event,
        inventory,
        location,
        organisation,
        team,
        user,
      ];

  void fromList(List<Permission> list) {
    club = list[0];
    competence = list[1];
    course = list[2];
    event = list[3];
    inventory = list[4];
    location = list[5];
    organisation = list[6];
    team = list[7];
    user = list[8];
  }
}
