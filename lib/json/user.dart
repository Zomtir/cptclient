// ignore_for_file: non_constant_identifier_names

import 'dart:core';

import 'package:cptclient/json/gender.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/utils/format.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class User extends FieldInterface implements Comparable {
  final int id;
  String key;
  bool? enabled;
  bool? active;
  String firstname;
  String lastname;
  String? nickname;
  String? address;
  String? email;
  String? phone;
  String? iban;
  DateTime? birthday;
  String? birthlocation;
  String? nationality;
  Gender? gender;
  int? federationnumber;
  DateTime? federationpermissionsolo;
  DateTime? federationpermissionteam;
  DateTime? federationresidency;
  String? note;

  User(this.id, this.key, this.active, this.firstname, this.lastname);

  User.fromInfo(this.id, this.key, this.firstname, this.lastname) : active = false;

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
        nickname = json['nickname'],
        address = json['address'],
        email = json['email'],
        phone = json['phone'],
        iban = json['iban'],
        birthday = parseIsoDate(json['birthday'])?.toLocal(),
        birthlocation = json['birthlocation'],
        nationality = json['nationality'],
        gender = Gender.fromNullString(json['gender']),
        federationnumber = convertNullInt(json['federationnumber']),
        federationpermissionsolo = parseIsoDate(json['federationpermissionsolo'])?.toLocal(),
        federationpermissionteam = parseIsoDate(json['federationpermissionteam'])?.toLocal(),
        federationresidency = parseIsoDate(json['federationresidency'])?.toLocal(),
        note = json['note'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'enabled': enabled,
        'active': active,
        'firstname': firstname,
        'lastname': lastname,
        'nickname': nickname,
        'address': address,
        'email': email,
        'phone': phone,
        'iban': iban,
        'birthday': formatIsoDate(birthday?.toUtc()),
        'birthlocation': birthlocation,
        'nationality': nationality,
        'gender': gender?.name,
        'federationnumber': federationnumber,
        'federationpermissionsolo': formatIsoDate(federationpermissionsolo?.toUtc()),
        'federationpermissionteam': formatIsoDate(federationpermissionteam?.toUtc()),
        'federationresidency': formatIsoDate(federationresidency?.toUtc()),
        'note': note
      };

  @override
  bool operator ==(other) => other is User && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    int compLast = removeDiacritics(lastname).compareTo(removeDiacritics(other.lastname));
    if (compLast != 0) return compLast;
    int compFirst = removeDiacritics(firstname).compareTo(removeDiacritics(other.firstname));
    if (compFirst != 0) return compFirst;

    return key.compareTo(other.key);
  }

  @override
  Widget buildEntry() {
    return Tooltip(
      message: "[$id] $key",
      child: Text("$firstname $lastname"),
    );
  }

  @override
  Widget buildTile() {
    return AppUserTile(user: this);
  }

  @override
  get searchable {
    return [key, firstname, lastname, nickname ?? ""];
  }
}
