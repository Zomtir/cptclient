import 'package:intl/intl.dart';

// ignore_for_file: non_constant_identifier_names

class User implements Comparable {
  final int id;
  String key;
  String? pwd;
  String firstname;
  String lastname;
  final bool enabled = false;

  User(this.id, this.key, this.pwd, this.firstname, this.lastname);

  User.fromVoid() :
    id = 0,
    key = "",
    pwd = "",
    firstname = "First Name",
    lastname = "Last Name";

  User.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    key = json['key'],
    pwd = json['pwd'],
    firstname = json['firstname'],
    lastname = json['lastname'];

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'key': key,
      'pwd': pwd,
      'firstname': firstname,
      'lastname': lastname,
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

