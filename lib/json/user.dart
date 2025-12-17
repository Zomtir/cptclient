// ignore_for_file: non_constant_identifier_names

import 'dart:core';

import 'package:cptclient/json/bankacc.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/gender.dart';
import 'package:cptclient/json/license.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/format.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class User extends FieldInterface implements Comparable {
  final int id;
  String key;
  bool? enabled;
  Credential? credential;
  bool? active;
  String firstname;
  String lastname;
  String? nickname;
  String? address;
  String? email;
  String? phone;
  DateTime? birth_date;
  String? birth_location;
  String? nationality;
  Gender? gender;
  int? height;
  int? weight;
  BankAccount? bank_account;
  License? license_main;
  License? license_extra;
  String? note;

  User(this.id, this.key, this.active, this.firstname, this.lastname);

  User.fromInfo(this.id, this.key, this.firstname, this.lastname) : active = false;

  User.fromVoid() : id = 0, key = "", firstname = "", lastname = "";

  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      key = json['key'],
      enabled = json['enabled'],
      credential = json['credential'] == null ? null : Credential.fromJson(json['credential']),
      active = json['active'],
      firstname = json['firstname'],
      lastname = json['lastname'],
      nickname = json['nickname'],
      address = json['address'],
      email = json['email'],
      phone = json['phone'],
      birth_date = parseIsoDate(json['birth_date']),
      birth_location = json['birth_location'],
      nationality = json['nationality'],
      gender = Gender.fromNullString(json['gender']),
      height = json['height'],
      weight = json['weight'],
      bank_account = json['bank_account'] == null ? null : BankAccount.fromJson(json['bank_account']),
      license_main = json['license_main'] == null ? null : License.fromJson(json['license_main']),
      license_extra = json['license_extra'] == null ? null : License.fromJson(json['license_extra']),
      note = json['note'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'enabled': enabled,
    'credential': credential,
    'active': active,
    'firstname': firstname,
    'lastname': lastname,
    'nickname': nickname,
    'address': address,
    'email': email,
    'phone': phone,
    'birth_date': formatIsoDate(birth_date),
    'birth_location': birth_location,
    'nationality': nationality,
    'gender': gender?.name,
    'height': height,
    'weight': weight,
    'bank_account': bank_account,
    'license_main': license_main,
    'license_extra': license_extra,
    'note': note,
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
  get searchable {
    return [key, firstname, lastname, nickname ?? ""];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(message: "[$id] $key", child: Text("$firstname $lastname"));
  }

  @override
  Widget buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$firstname $lastname"),
        if (nickname != null) Text(nickname!, style: TextStyle(fontStyle: FontStyle.italic)),
      ],
    );
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "$key", child: Icon(Icons.person)),
      trailing: trailing,
      child: Text.rich(
        TextSpan(
          style: Theme.of(context).textTheme.bodyLarge,
          children: [
            TextSpan(text: "$firstname $lastname"),
            if (nickname != null)
              TextSpan(
                text: "\t($nickname)",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Tooltip(child: Icon(Icons.person), message: "$key"),
      trailing: trailing,
      children: [
        Text("$firstname $lastname"),
        if (nickname != null) Text(nickname!),
      ],
    );
  }
}
