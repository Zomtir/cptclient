import 'package:intl/intl.dart';

// ignore_for_file: non_constant_identifier_names

class User implements Comparable {
  final int id;
  String key;
  String? pwd;
  String firstname;
  String lastname;

  final bool enabled = false;
  final bool admin_users;
  final bool admin_rankings;
  final bool admin_reservations;
  final bool admin_courses;

  User(this.id, this.key, this.pwd, this.firstname, this.lastname,
      {this.admin_users = false, this.admin_rankings = false, this.admin_reservations = false, this.admin_courses = false });

  User.fromVoid() :
    id = 0,
    key = "",
    pwd = "",
    firstname = "First Name",
    lastname = "Last Name",
    // TODO Probably "member" should be used instead of user in the user list?
    admin_users = false,
    admin_rankings = false,
    admin_reservations = false,
    admin_courses = false;

  User.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    key = json['key'],
    pwd = json['pwd'],
    firstname = json['firstname'],
    lastname = json['lastname'],

    admin_users = json['admin_users'],
    admin_rankings = json['admin_rankings'],
    admin_reservations = json['admin_reservations'],
    admin_courses = json['admin_courses'];

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'key': key,
      'pwd': pwd,
      'firstname': firstname,
      'lastname': lastname,

      'admin_users': admin_users,
      'admin_rankings': admin_rankings,
      'admin_reservations': admin_reservations,
      'admin_courses': admin_courses,
    };

  bool operator == (other) => other is User && id == other.id;
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    int compLast = this.lastname.compareTo(other.lastname);

    if (compLast != 0)
      return compLast;

    int compFirst = this.firstname.compareTo(other.firstname);

    if (compFirst != 0)
      return compFirst;

    return this.key.compareTo(other.key);
  }

}

