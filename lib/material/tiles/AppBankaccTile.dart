import 'package:cptclient/json/bankacc.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppBankAccountTile extends StatelessWidget {
  final BankAccount bankacc;
  final List<Widget> trailing;

  const AppBankAccountTile(
    this.bankacc, {
    super.key,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message: "[${bankacc.id}]",
              child: Icon(Icons.account_balance),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${bankacc.iban}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${bankacc.institute} (${bankacc.bic})"),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
