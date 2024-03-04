// ignore_for_file: non_constant_identifier_names

class Right {
  bool admin_competence;
  bool admin_courses;
  bool admin_event;
  bool admin_inventory;
  bool admin_teams;
  bool admin_term;
  bool admin_users;

  Right({
    this.admin_competence = false,
    this.admin_courses = false,
    this.admin_event = false,
    this.admin_inventory = false,
    this.admin_teams = false,
    this.admin_term = false,
    this.admin_users = false,
  });

  Right.fromRight(Right right)
      : admin_competence = right.admin_competence,
        admin_courses = right.admin_courses,
        admin_event = right.admin_event,
        admin_inventory = right.admin_inventory,
        admin_teams = right.admin_teams,
        admin_term = right.admin_term,
        admin_users = right.admin_users;

  Right.fromJson(Map<String, dynamic> json)
      : admin_competence = json['admin_competence'],
        admin_courses = json['admin_courses'],
        admin_event = json['admin_event'],
        admin_inventory = json['admin_inventory'],
        admin_teams = json['admin_teams'],
        admin_term = json['admin_term'],
        admin_users = json['admin_users'];

  Map<String, dynamic> toJson() => {
        'admin_competence': admin_competence,
        'admin_courses': admin_courses,
        'admin_event': admin_event,
        'admin_inventory': admin_inventory,
        'admin_teams': admin_teams,
        'admin_term': admin_term,
        'admin_users': admin_users,
      };
}
