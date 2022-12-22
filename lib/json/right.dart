// ignore_for_file: non_constant_identifier_names

class Right {
  bool admin_courses;
  bool admin_inventory;
  bool admin_event;
  bool admin_rankings;
  bool admin_teams;
  bool admin_users;

  Right({
    this.admin_courses = false,
    this.admin_inventory = false,
    this.admin_event = false,
    this.admin_rankings = false,
    this.admin_teams = false,
    this.admin_users = false,
  });

  Right.fromRight(Right right)
      : admin_courses = right.admin_courses,
        admin_inventory = right.admin_inventory,
        admin_event = right.admin_event,
        admin_rankings = right.admin_rankings,
        admin_teams = right.admin_teams,
        admin_users = right.admin_users;

  Right.fromJson(Map<String, dynamic> json)
      : admin_courses = json['admin_courses'],
        admin_inventory = json['admin_inventory'],
        admin_event = json['admin_event'],
        admin_rankings = json['admin_rankings'],
        admin_teams = json['admin_teams'],
        admin_users = json['admin_users'];

  Map<String, dynamic> toJson() => {
        'admin_courses': admin_courses,
        'admin_inventory': admin_inventory,
        'admin_event': admin_event,
        'admin_rankings': admin_rankings,
        'admin_teams': admin_teams,
        'admin_users': admin_users,
      };
}
