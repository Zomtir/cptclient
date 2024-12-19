import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Gender implements Comparable {
  final String _value;

  const Gender._init(this._value);

  static const List<Gender> values = [
    Gender._init('MALE'),
    Gender._init('FEMALE'),
    Gender._init('OTHER'),
  ];

  String get name => _value;

  static Gender get empty => const Gender._init('NULL');

  static Gender get male => const Gender._init('MALE');

  static Gender get female => const Gender._init('FEMALE');

  static Gender get other => const Gender._init('OTHER');

  static Gender? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((confirmation) => confirmation._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid Gender value'));
  }

  String localizedName(BuildContext context) {
    if (this == Gender.empty) {
      return AppLocalizations.of(context)!.undefined;
    } else if (this == Gender.male) {
      return AppLocalizations.of(context)!.genderMale;
    } else if (this == Gender.female) {
      return AppLocalizations.of(context)!.genderFemale;
    } else if (this == Gender.other) {
      return AppLocalizations.of(context)!.genderOther;
    } else {
      return '';
    }
  }

  @override
  bool operator ==(other) => other is Gender && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}
