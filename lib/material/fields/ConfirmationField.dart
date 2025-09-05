import 'package:cptclient/json/confirmation.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// TODO maybe remove if not needed
class ConfirmationField extends StatelessWidget {
  final Confirmation confirmation;
  final void Function(Confirmation?) onChanged;
  final bool nullable;

  ConfirmationField({
    super.key,
    required this.confirmation,
    required this.onChanged,
    this.nullable = true,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<Confirmation>(
      groupValue: confirmation,
      onChanged: onChanged,
      child: Row(
        children: <Widget>[
          Expanded(
            child: RadioListTile<Confirmation>(
              value: Confirmation.positive,
              title: Text(AppLocalizations.of(context)!.confirmationPositive),
              toggleable: true,
              dense: true,
              contentPadding: EdgeInsets.all(0),
            ),
          ),
          Expanded(
            child: RadioListTile<Confirmation>(
              value: Confirmation.neutral,
              title: Text(AppLocalizations.of(context)!.confirmationNeutral),
              toggleable: true,
              dense: true,
              contentPadding: EdgeInsets.all(0),
            ),
          ),
          Expanded(
            child: RadioListTile<Confirmation>(
              value: Confirmation.negative,
              title: Text(AppLocalizations.of(context)!.confirmationNegative),
              toggleable: true,
              dense: true,
              contentPadding: EdgeInsets.all(0),
            ),
          ),
        ],
      ),
    );
  }
}
