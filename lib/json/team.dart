// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/right.dart';

class Team implements Comparable {
  final int id;
  String name;
  String description;
  Right? right;

  Team(this.id, this.name, this.description);

  Team.fromVoid()
      : id = 0,
        name = "",
        description = "";

  Team.fromTeam(Team team)
      : this.id = 0,
        this.name = team.name + " (Copy)",
        this.description = team.description,
        this.right = (team.right == null) ? null : Right.fromRight(team.right!);

  Team.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        right = Right.fromJson(json['right']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'right': right?.toJson(),
      };

  bool operator ==(other) => other is Team && id == other.id;

  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return this.name.compareTo(other.name);
  }
}
