import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class Gender extends FieldInterface implements Comparable {
  final String _value;

  const Gender._init(this._value);

  static const List<Gender> values = [
    Gender.male,
    Gender.female,
    Gender.other,
  ];

  String get name => _value;

  static const Gender empty = Gender._init('NULL');
  static const Gender male = Gender._init('MALE');
  static const Gender female = Gender._init('FEMALE');
  static const Gender other = Gender._init('OTHER');

  static Gender? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((confirmation) => confirmation._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid Gender value'));
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      Gender.male => AppLocalizations.of(context)!.genderMale,
      Gender.female => AppLocalizations.of(context)!.genderFemale,
      Gender.other => AppLocalizations.of(context)!.genderOther,
      _ => AppLocalizations.of(context)!.undefined,
    };
  }

  @override
  bool operator ==(other) => other is Gender && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Text(localizedName(context));
  }

  @override
  Widget buildTile(BuildContext context) {
    return ListTile(title: Text(localizedName(context)));
  }

  @override
  get searchable {
    return [name];
  }
}
