import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Occurrence implements Comparable {
  final String _value;

  const Occurrence._init(this._value);

  static const List<Occurrence> values = [
    Occurrence._init('OCCURRING'),
    Occurrence._init('CANCELED'),
    Occurrence._init('VOIDED'),
  ];

  String get name => _value;

  static Occurrence get empty => const Occurrence._init('NULL');

  static Occurrence get occurring => const Occurrence._init('OCCURRING');

  static Occurrence get canceled => const Occurrence._init('CANCELED');

  static Occurrence get voided => const Occurrence._init('VOIDED');

  static Occurrence? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((confirmation) => confirmation._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid Occurrence value'));
  }

  String localizedName(BuildContext context) {
    if (this == Occurrence.empty) {
      return AppLocalizations.of(context)!.undefined;
    } else if (this == Occurrence.occurring) {
      return AppLocalizations.of(context)!.occurrenceOccurring;
    } else if (this == Occurrence.canceled) {
      return AppLocalizations.of(context)!.occurrenceCanceled;
    } else if (this == Occurrence.voided) {
      return AppLocalizations.of(context)!.occurrenceVoided;
    } else {
      return '';
    }
  }

  @override
  bool operator ==(other) => other is Occurrence && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}
