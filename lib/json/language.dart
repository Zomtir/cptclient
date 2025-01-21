// ignore_for_file: constant_identifier_names

import 'package:cptclient/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class Language implements Comparable {
  Locale locale;

  Language(this.locale);

  static List<Language> get entries {
    return List<Language>.from(AppLocalizations.supportedLocales.map((locale) => Language(locale)));
  }

  String localizedName(BuildContext context) {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizations.of(context)!.language_en;
      case 'de':
        return AppLocalizations.of(context)!.language_de;
      default:
        return '';
    }
  }

  @override
  bool operator ==(other) => other is Language && locale.hashCode == other.locale.hashCode;

  @override
  int get hashCode => locale.hashCode;

  @override
  int compareTo(other) {
    return locale.languageCode.compareTo(other.locale.languageCode);
  }
}
