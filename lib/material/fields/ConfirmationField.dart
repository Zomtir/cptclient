import 'package:cptclient/json/confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Row(
      children: [
        Expanded(
          child: RadioListTile<Confirmation>(
            value: Confirmation.empty,
            groupValue: confirmation,
            title: Text(AppLocalizations.of(context)!.unknown),
            onChanged: onChanged,
            dense: true,
            contentPadding: EdgeInsets.all(0),
          ),
        ),
        Expanded(
          child: RadioListTile<Confirmation>(
            value: Confirmation.positive,
            groupValue: confirmation,
            title: Text(AppLocalizations.of(context)!.confirmationPositive),
            onChanged: onChanged,
            dense: true,
            contentPadding: EdgeInsets.all(0),
          ),
        ),
        Expanded(
          child: RadioListTile<Confirmation>(
            value: Confirmation.neutral,
            groupValue: confirmation,
            title: Text(AppLocalizations.of(context)!.confirmationNeutral),
            onChanged: onChanged,
            dense: true,
            contentPadding: EdgeInsets.all(0),
          ),
        ),
        Expanded(
          child: RadioListTile<Confirmation>(
            value: Confirmation.negative,
            groupValue: confirmation,
            title: Text(AppLocalizations.of(context)!.confirmationNegative),
            onChanged: onChanged,
            dense: true,
            contentPadding: EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }
}
