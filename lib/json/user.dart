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
  DateTime? birth_date;
  String? birth_location;
  String? nationality;
  Gender? gender;
  int? height;
  int? weight;
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
        birth_date = parseIsoDate(json['birth_date'])?.toLocal(),
        birth_location = json['birth_location'],
        nationality = json['nationality'],
        gender = Gender.fromNullString(json['gender']),
        height = json['height'],
        weight = json['weight'],
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
        'birth_date': formatIsoDate(birth_date?.toUtc()),
        'birth_location': birth_location,
        'nationality': nationality,
        'gender': gender?.name,
        'height': height,
        'weight': weight,
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
