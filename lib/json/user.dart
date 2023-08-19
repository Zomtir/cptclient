// ignore_for_file: non_constant_identifier_names

import 'dart:core';

import 'package:cptclient/static/format.dart';

class User implements Comparable {
  final int id;
  String key;
  bool? enabled;
  bool? active;
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
  int? federationnumber;
  DateTime? federationpermissionsolo;
  DateTime? federationpermissionteam;
  DateTime? federationresidency;
  int? datadeclaration;
  String? datadisclaimer;
  String? note;

  User(this.id, this.key, this.active, this.firstname, this.lastname);

  User.fromInfo(this.id, this.key, this.firstname, this.lastname) : this.active = false;

  User.fromVoid()
      : id = 0,
        key = "",
        firstname = "",
        lastname = "";

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        enabled = json['enabled'],
        active = json['active'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        address = json['address'],
        email = json['email'],
        phone = json['phone'],
        iban = json['iban'],
        birthday = parseNullWebDate(json['birthday']),
        birthlocation = json['birthlocation'],
        nationality = json['nationality'],
        gender = json['gender'],
        federationnumber = convertNullInt(json['federationnumber']),
        federationpermissionsolo = parseNullWebDate(json['federationpermissionsolo']),
        federationpermissionteam = parseNullWebDate(json['federationpermissionteam']),
        federationresidency = json['federationresidency'],
        datadeclaration = convertNullInt(json['datadeclaration']),
        datadisclaimer = json['datadisclaimer'],
        note = json['note'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'enabled': enabled,
        'active': active,
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
        'federationnumber': federationnumber,
        'federationpermissionsolo': formatNullWebDate(federationpermissionsolo),
        'federationpermissionteam': formatNullWebDate(federationpermissionteam),
        'federationresidency': formatNullWebDate(federationresidency),
        'datadeclaration': datadeclaration,
        'datadisclaimer': datadisclaimer,
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

List<User> filterUsers(List<User> users, String filter) {
  List<User> filtered = users.where((User user) {
    Set<String> fragments = filter.toLowerCase().split(' ').toSet();
    List<String> searchspace = [user.key, user.firstname, user.lastname];

    for (var fragment in fragments) {
      bool matchedAny = false;
      for (var space in searchspace) {
        matchedAny = matchedAny || space.toLowerCase().contains(fragment);
      }
      if (!matchedAny) return false;
    }

    return true;
  }).toList();

  return filtered;
}
