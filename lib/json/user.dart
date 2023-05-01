// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/static/format.dart';

class User implements Comparable {
  final int id;
  String key;
  bool? enabled;
  String firstname;
  String lastname;
  String? address;
  String? email;
  String? phone;
  String? iban;
  DateTime? birthday;
  String? birthlocation;
  String? nationality;
  String? gender;
  int? federationNumber;
  DateTime? federationPermissionSolo;
  DateTime? federationPermissionTeam;
  DateTime? federationResidency;
  int? dataDeclaration;
  String? dataDisclaimer;
  String? note;

  User(this.id, this.key, this.enabled, this.firstname, this.lastname);

  User.fromInfo(this.id, this.key, this.firstname, this.lastname) : this.enabled = false;

  User.fromVoid()
      : id = 0,
        key = "",
        firstname = "First Name",
        lastname = "Last Name";

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        enabled = json['enabled'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        address = json['address'],
        email = json['email'],
        phone = json['phone'],
        iban = json['iban'],
        birthday = parseWebDate(json['birthday']),
        birthlocation = json['birthlocation'],
        nationality = json['nationality'],
        gender = json['gender'],
        federationNumber = parseNullInt(json['federationNumber']),
        federationPermissionSolo = parseWebDate(json['federationPermissionSolo']),
        federationPermissionTeam = parseWebDate(json['federationPermissionTeam']),
        federationResidency = json['federationResidency'],
        dataDeclaration = parseNullInt(json['dataDeclaration']),
        dataDisclaimer = json['dataDisclaimer'],
        note = json['note'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'enabled': enabled,
        'firstname': firstname,
        'lastname': lastname,
        'address': address,
        'email': email,
        'phone': phone,
        'iban': iban,
        'birthday': formatNullWebDate(birthday),
        'birthlocation': birthlocation,
        'nationality': nationality,
        'gender': gender,
        'federationNumber': formatNullInt(federationNumber),
        'federationPermissionSolo': formatNullWebDate(federationPermissionSolo),
        'federationPermissionTeam': formatNullWebDate(federationPermissionTeam),
        'federationResidency': formatNullWebDate(federationResidency),
        'dataDeclaration': formatNullInt(dataDeclaration),
        'dataDisclaimer': dataDisclaimer,
        'note': note
      };

  bool operator ==(other) => other is User && id == other.id;

  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    int compLast = this.lastname.compareTo(other.lastname);

    if (compLast != 0) return compLast;

    int compFirst = this.firstname.compareTo(other.firstname);

    if (compFirst != 0) return compFirst;

    return this.key.compareTo(other.key);
  }
}
