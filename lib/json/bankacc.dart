import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/tiles/AppBankaccTile.dart';
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
  Widget buildEntry() {
    return Tooltip(
      message: "[$id]",
      child: Text("$iban"),
    );
  }

  @override
  Widget buildTile() {
    return AppBankAccountTile(this);
  }

  @override
  get searchable {
    return [iban, bic];
  }
}
