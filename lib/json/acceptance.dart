import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Acceptance implements Comparable {
  final String _value;

  const Acceptance._init(this._value);

  static const List<Acceptance> values = [
    Acceptance._init('DRAFT'),
    Acceptance._init('PENDING'),
    Acceptance._init('ACCEPTED'),
    Acceptance._init('REJECTED'),
  ];

  String get name => _value;

  static Acceptance get empty => const Acceptance._init('NULL');

  static Acceptance get draft => const Acceptance._init('DRAFT');

  static Acceptance get pending => const Acceptance._init('PENDING');

  static Acceptance get accepted => const Acceptance._init('ACCEPTED');

  static Acceptance get rejected => const Acceptance._init('REJECTED');

  static Acceptance? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((confirmation) => confirmation._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid Acceptance value'));
  }

  String localizedName(BuildContext context) {
    if (this == Acceptance.empty) {
      return AppLocalizations.of(context)!.undefined;
    } else if (this == Acceptance.draft) {
      return AppLocalizations.of(context)!.acceptanceDraft;
    } else if (this == Acceptance.pending) {
      return AppLocalizations.of(context)!.acceptancePending;
    } else if (this == Acceptance.accepted) {
      return AppLocalizations.of(context)!.acceptanceAccepted;
    } else if (this == Acceptance.rejected) {
      return AppLocalizations.of(context)!.acceptanceRejected;
    } else {
      return '';
    }
  }

  @override
  bool operator ==(other) => other is Acceptance && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}
