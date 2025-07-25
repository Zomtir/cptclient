import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class Confirmation extends FieldInterface implements Comparable {
  final String _value;

  const Confirmation._init(this._value);

  static const List<Confirmation> values = [
    Confirmation.positive,
    Confirmation.neutral,
    Confirmation.negative
  ];

  String get name => _value;

  static const Confirmation empty = Confirmation._init('NULL');
  static const Confirmation positive = Confirmation._init('POSITIVE');
  static const Confirmation neutral = Confirmation._init('NEUTRAL');
  static const Confirmation negative = Confirmation._init('NEGATIVE');

  static Confirmation? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((confirmation) => confirmation._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid confirmation value'));
  }

  String localizedName(BuildContext context) {
    if (this == Confirmation.empty) {
      return AppLocalizations.of(context)!.undefined;
    } else if (this == Confirmation.positive) {
      return AppLocalizations.of(context)!.confirmationPositive;
    } else if (this == Confirmation.neutral) {
      return AppLocalizations.of(context)!.confirmationNeutral;
    } else if (this == Confirmation.negative) {
      return AppLocalizations.of(context)!.confirmationNegative;
    } else {
      return '';
    }
  }

  @override
  bool operator ==(other) => other is Confirmation && _value == other._value;

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
