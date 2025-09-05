import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppCard.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class Credential extends FieldInterface {
  final String? login;
  final String? password;
  final String? salt;
  final DateTime? since;

  Credential({this.login, this.password, this.salt, this.since});

  @override
  Credential.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        password = json['password'],
        salt = json['salt'],
        since = parseIsoDateTime(json['since'])?.toLocal();

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
        'salt': salt,
        'since': formatIsoDateTime(since?.toUtc()),
      };


  @override
  int compareTo(other) {
    throw UnimplementedError();
  }

  @override
  get searchable {
    return [];
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Text("${AppLocalizations.of(context)!.userPasswordSince} ${since?.fmtDateTime(context) ?? AppLocalizations.of(context)!.undefined}");
  }

  @override
  Widget buildInfo(BuildContext context) {
    return Text("${AppLocalizations.of(context)!.userPasswordSince} ${since?.fmtDateTime(context) ?? AppLocalizations.of(context)!.undefined}");
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Icon(Icons.password),
      child: Text(AppLocalizations.of(context)!.userPasswordSince),
      child2: Text(since!.fmtDateTime(context)),
    );
  }

  @override
  Widget buildCard(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppCard(
      leading: Icon(Icons.password),
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.userPasswordSince),
          subtitle: Text(since!.fmtDateTime(context)),
        ),
      ],
    );
  }
}
