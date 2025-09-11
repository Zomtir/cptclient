import 'package:cptclient/json/bankacc.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class BankAccountEdit extends StatefulWidget {
  final BankAccount initialValue;
  final VoidCallback? onDelete;
  final Function(BankAccount)? onConfirm;

  BankAccountEdit({super.key, required this.initialValue, this.onDelete, this.onConfirm});

  @override
  BankAccountEditState createState() => BankAccountEditState();
}

class BankAccountEditState extends State<BankAccountEdit> {
  late BankAccount currentValue;
  final TextEditingController _ctrlIban = TextEditingController();
  final TextEditingController _ctrlBic = TextEditingController();
  final TextEditingController _ctrlInstitute = TextEditingController();

  BankAccountEditState();

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    _ctrlIban.text = currentValue.iban;
    _ctrlBic.text = currentValue.bic;
    _ctrlInstitute.text = currentValue.institute;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        children: [
          widget.initialValue.buildTile(context),
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
        ],
      ),
      actions: [
        if (widget.onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete?.call();
              Navigator.pop(context);
            },
          ),
        if (widget.onConfirm != null)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_ctrlIban.text.isEmpty) {
                messageText("${AppLocalizations.of(context)!.bankaccIban} ${AppLocalizations.of(context)!.isInvalid}");
                return;
              }

              if (_ctrlBic.text.isEmpty) {
                messageText("${AppLocalizations.of(context)!.bankaccBic} ${AppLocalizations.of(context)!.isInvalid}");
                return;
              }

              if (_ctrlInstitute.text.isEmpty) {
                messageText("${AppLocalizations.of(context)!.bankaccInstitute} ${AppLocalizations.of(context)!.isInvalid}");
                return;
              }

              currentValue.iban = _ctrlIban.text;
              currentValue.bic = _ctrlBic.text;
              currentValue.institute = _ctrlInstitute.text;

              widget.onConfirm?.call(currentValue);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}