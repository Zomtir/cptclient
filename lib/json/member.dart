import 'package:cptclient/json/user.dart';

class Member implements Comparable {
  final int id;
  final String key;
  final String firstname;
  final String lastname;

  Member(this.id, this.key, this.firstname, this.lastname);

  Member.fromUser(User user) :
    id = user.id,
    key = user.key,
    firstname = user.firstname,
    lastname = user.lastname;

  Member.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    key = json['key'],
    firstname = json['firstname'],
    lastname = json['lastname'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'firstname': firstname,
    'lastname': lastname,
  };

  bool operator == (other) => other is Member && id == other.id;
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

