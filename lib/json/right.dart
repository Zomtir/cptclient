// ignore_for_file: non_constant_identifier_names
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class Permission {
  final String id;
  final bool read;
  final bool write;

  const Permission(this.id, {this.read = false, this.write = false});

  Permission copyWith({bool? read, bool? write}) => Permission(
        id,
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
    this.club = const Permission("club", read: false, write: false),
    this.competence = const Permission("competence", read: false, write: false),
    this.course = const Permission("course", read: false, write: false),
    this.event = const Permission("event", read: false, write: false),
    this.inventory = const Permission("inventory", read: false, write: false),
    this.location = const Permission("location", read: false, write: false),
    this.organisation = const Permission("organisation", read: false, write: false),
    this.team = const Permission("team", read: false, write: false),
    this.user = const Permission("user", read: false, write: false),
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
          read: json['right_club_read'],
          write: json['right_club_write'],
        ),
        competence = Permission(
          "competence",
          read: json['right_competence_read'],
          write: json['right_competence_write'],
        ),
        course = Permission(
          "course",
          read: json['right_course_read'],
          write: json['right_course_write'],
        ),
        event = Permission(
          "event",
          read: json['right_event_read'],
          write: json['right_event_write'],
        ),
        inventory = Permission(
          "inventory",
          read: json['right_inventory_read'],
          write: json['right_inventory_write'],
        ),
        location = Permission(
          "location",
          read: json['right_location_read'],
          write: json['right_location_write'],
        ),
        organisation = Permission(
          "organisation",
          read: json['right_organisation_read'],
          write: json['right_organisation_write'],
        ),
        team = Permission(
          "team",
          read: json['right_team_read'],
          write: json['right_team_write'],
        ),
        user = Permission(
          "user",
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

  static List<String> localeList(BuildContext context) => [
        AppLocalizations.of(context)!.club,
        AppLocalizations.of(context)!.competence,
        AppLocalizations.of(context)!.course,
        AppLocalizations.of(context)!.event,
        AppLocalizations.of(context)!.inventory,
        AppLocalizations.of(context)!.location,
        AppLocalizations.of(context)!.organisation,
        AppLocalizations.of(context)!.team,
        AppLocalizations.of(context)!.user,
      ];
}