// ignore_for_file: non_constant_identifier_names

class Team implements Comparable {
  final int id;
  String name;
  String description;
  bool right_user_edit = false;
  bool right_ranking_edit = false;
  bool right_reservation_edit = false;
  bool right_course_edit = false;

  Team(this.id, this.name, this.description);

  Team.fromVoid() :
    id = 0,
    name = "",
    description = "";

  Team.fromTeam(Team team) :
    this.id = 0,
    this.name = team.name + " (Copy)",
    this.description = team.description,
    this.right_course_edit = team.right_course_edit,
    this.right_ranking_edit = team.right_ranking_edit,
    this.right_reservation_edit = team.right_reservation_edit,
    this.right_user_edit = team.right_user_edit;

  Team.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'],
    description = json['description'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };

  bool operator == (other) => other is Team && id == other.id;
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return this.name.compareTo(other.name);
  }

}
