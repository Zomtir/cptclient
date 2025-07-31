import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class Valence extends FieldInterface implements Comparable {
  final String _value;

  const Valence._init(this._value);

  static const List<Valence> values = [
    Valence.yes,
    Valence.maybe,
    Valence.no
  ];

  String get name => _value;

  static const Valence empty = Valence._init('NULL');
  static const Valence yes = Valence._init('YES');
  static const Valence maybe = Valence._init('MAYBE');
  static const Valence no = Valence._init('NO');

  static Valence? fromBool(bool? valence, {enabled = true}) {
    if (!enabled) return null;
    return switch (valence) {
      true => Valence.yes,
      false => Valence.no,
      _ => Valence.maybe,
    };
  }

  bool? toBool() {
    return switch (this) {
      Valence.yes => true,
      Valence.no => false,
      _ => null,
    };
  }

  static Valence? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((valence) => valence._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid valence value'));
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      Valence.yes => AppLocalizations.of(context)!.labelTrue,
      Valence.maybe => AppLocalizations.of(context)!.labelNeutral,
      Valence.no => AppLocalizations.of(context)!.labelFalse,
      _ => AppLocalizations.of(context)!.undefined,
    };
  }

  @override
  bool operator ==(other) => other is Valence && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }

  @override
  get searchable {
    return [name];
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
  Widget buildCard(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }
}
