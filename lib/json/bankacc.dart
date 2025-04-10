import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:flutter/material.dart';

class BankAccount extends FieldInterface implements Comparable {
  final int id;
  String iban;
  String bic;
  String institute;

  BankAccount(this.id, this.iban, this.bic, this.institute);

  BankAccount.fromVoid()
      : id = 0,
        iban = "",
        bic = "",
        institute = "";

  BankAccount.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        iban = json['iban'],
        bic = json['bic'],
        institute = json['institute'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'iban': iban,
        'bic': bic,
        'institute': institute,
      };

  @override
  bool operator ==(other) => other is BankAccount && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return iban.compareTo(other.iban);
  }

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id]",
      child: Text("${iban.isEmpty ? AppLocalizations.of(context)!.undefined : iban}"),
    );
  }

  @override
  Widget buildTile(BuildContext context) {
    return AppTile(
      icon: Tooltip(
        message: "[$id]",
        child: Icon(Icons.account_balance),
      ),
      children: [
        Text("${iban.isEmpty ? AppLocalizations.of(context)!.undefined : iban}", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("${institute.isEmpty ? AppLocalizations.of(context)!.undefined : institute} (${bic.isEmpty ? AppLocalizations.of(context)!.undefined : bic})"),
      ],
    );
  }

  @override
  get searchable {
    return [iban, bic];
  }

  // TODO
  static Widget buildEntryStatic(BuildContext context, BankAccount? ba) {
    if (ba == null) {
      return Text(AppLocalizations.of(context)!.labelMissing);
    }
    return Column(
      children: [
        Text("${ba.iban.isEmpty ? AppLocalizations.of(context)!.undefined : ba.iban}"),
        Text("${ba.institute.isEmpty ? AppLocalizations.of(context)!.undefined : ba.institute} (${ba.bic.isEmpty ? AppLocalizations.of(context)!.undefined : ba.bic})"),
      ],
    );
  }

  // TODO
  static String copyEntryStatic(BuildContext context, BankAccount? ba) {
    if (ba == null) {
      return "";
    }
    return "${ba.iban.isEmpty ? AppLocalizations.of(context)!.undefined : ba.iban},"
      "${ba.institute.isEmpty ? AppLocalizations.of(context)!.undefined : ba.institute}"
      "(${ba.bic.isEmpty ? AppLocalizations.of(context)!.undefined : ba.bic})";
  }
}
