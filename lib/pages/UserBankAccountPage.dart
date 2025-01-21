import 'package:cptclient/json/bankacc.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppBankaccTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';

class UserBankAccountPage extends StatefulWidget {
  final BankAccount bankacc;
  final Future<void> Function(BankAccount) onEdit;

  UserBankAccountPage({super.key, required this.bankacc, required this.onEdit});

  @override
  UserBankAccountPageState createState() => UserBankAccountPageState();
}

class UserBankAccountPageState extends State<UserBankAccountPage> {
  final TextEditingController _ctrlIban = TextEditingController();
  final TextEditingController _ctrlBic = TextEditingController();
  final TextEditingController _ctrlInstitute = TextEditingController();

  UserBankAccountPageState();

  @override
  void initState() {
    super.initState();
    _apply();
  }

  void _apply() {
    _ctrlIban.text = widget.bankacc.iban;
    _ctrlBic.text = widget.bankacc.bic;
    _ctrlInstitute.text = widget.bankacc.institute;
  }

  void _gather() {
    if (_ctrlIban.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.bankaccIban} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (_ctrlBic.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.bankaccBic} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (_ctrlInstitute.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("${AppLocalizations.of(context)!.bankaccInstitute} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    widget.bankacc.iban = _ctrlIban.text;
    widget.bankacc.bic = _ctrlBic.text;
    widget.bankacc.institute = _ctrlInstitute.text;
  }

  void _submit() async {
    _gather();
    await widget.onEdit(widget.bankacc);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageUserEdit),
      ),
      body: AppBody(
        children: [
          AppBankAccountTile(widget.bankacc),
          AppInfoRow(
            info: AppLocalizations.of(context)!.bankaccIban,
            child: TextField(
              maxLines: 1,
              controller: _ctrlIban,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.bankaccBic,
            child: TextField(
              maxLines: 1,
              controller: _ctrlBic,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.bankaccInstitute,
            child: TextField(
              maxLines: 1,
              controller: _ctrlInstitute,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
