// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum GenderStatus {
  MALE,
  FEMALE,
  OTHER,
}

class Gender implements Comparable {
  GenderStatus status;

  Gender(this.status);

  static Gender? fromNullString(String? status) {
    if (status == null) return null;
    if (status == 'NULL') return null;

    return Gender(GenderStatus.values.byName(status));
  }

  static List<Gender> get entries {
    return List<Gender>.from(GenderStatus.values.map((model) => Gender(model)));
  }

  String get name {
    return status.name;
  }

  @override
  bool operator ==(other) => other is Gender && status == other.status;

  @override
  int get hashCode => status.hashCode;

  @override
  int compareTo(other) {
    return status.name.compareTo(other.acceptance.name);
  }
}

extension LocalelizationExtension on GenderStatus {
  String localizedName(BuildContext context) {
    switch (this) {
      case GenderStatus.MALE:
        return AppLocalizations.of(context)!.genderMale;
      case GenderStatus.FEMALE:
        return AppLocalizations.of(context)!.genderFemale;
      case GenderStatus.OTHER:
        return AppLocalizations.of(context)!.genderOther;
      default:
        return '';
    }
  }
}
