import 'package:cptclient/json/bankacc.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class BankAccountEdit extends StatefulWidget {
  final BankAccount bankacc;

  BankAccountEdit({super.key, required this.bankacc});

  @override
  BankAccountEditState createState() => BankAccountEditState();
}

class BankAccountEditState extends State<BankAccountEdit> {
  final TextEditingController _ctrlIban = TextEditingController();
  final TextEditingController _ctrlBic = TextEditingController();
  final TextEditingController _ctrlInstitute = TextEditingController();

  BankAccountEditState();

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

  bool _gather() {
    if (_ctrlIban.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.bankaccIban} ${AppLocalizations.of(context)!.isInvalid}")));
      return false;
    }

    if (_ctrlBic.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.bankaccBic} ${AppLocalizations.of(context)!.isInvalid}")));
      return false;
    }

    if (_ctrlInstitute.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("${AppLocalizations.of(context)!.bankaccInstitute} ${AppLocalizations.of(context)!.isInvalid}")));
      return false;
    }

    widget.bankacc.iban = _ctrlIban.text;
    widget.bankacc.bic = _ctrlBic.text;
    widget.bankacc.institute = _ctrlInstitute.text;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Widget actions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AppButton(
          onPressed: () => Navigator.pop(context),
          text: AppLocalizations.of(context)!.actionCancel,
        ),
        Spacer(),
        AppButton(
          onPressed: () => Navigator.pop(context, Success(null)),
          text: AppLocalizations.of(context)!.actionRemove,
        ),
        Spacer(),
        AppButton(
          onPressed: () async {
            if (!_gather()) return;
            Navigator.pop(context, Success(widget.bankacc));
          },
          text: AppLocalizations.of(context)!.actionConfirm,
        ),
      ],
    );

    return Column(
      children: [
        widget.bankacc.buildTile(context),
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
        actions,
      ],
    );
  }
}
