import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class Role extends FieldInterface implements Comparable {
  final String _value;

  const Role._init(this._value);

  static const List<Role> values = [
    Role.leader,
    Role.supporter,
    Role.participant,
    Role.spectator,
  ];

  String get name => _value;
  
  static const Role leader = Role._init('LEADER');
  static const Role supporter = Role._init('SUPPORTER');
  static const Role participant = Role._init('PARTICIPANT');
  static const Role spectator = Role._init('SPECTATOR');

  static Role? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((confirmation) => confirmation._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid Role Value'));
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      Role.leader => AppLocalizations.of(context)!.eventLeader,
      Role.supporter => AppLocalizations.of(context)!.eventSupporter,
      Role.participant => AppLocalizations.of(context)!.eventParticipant,
      Role.spectator => AppLocalizations.of(context)!.eventSpectator,
      _ => AppLocalizations.of(context)!.undefined,
    };
  }

  @override
  bool operator ==(other) => other is Role && _value == other._value;

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
  Widget buildInfo(BuildContext context) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return ListTile(title: Text(localizedName(context)));
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    // TODO: implement buildEntry
    throw UnimplementedError();
  }
}
