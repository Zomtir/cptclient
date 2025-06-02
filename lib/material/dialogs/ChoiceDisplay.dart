import 'package:cptclient/json/valence.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ChoiceDisplay extends StatelessWidget {
  ChoiceDisplay({
    super.key,
    required this.value,
    this.trailing,
  });

  final Valence? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: switch (value) {
        Valence.maybe => Icon(Icons.indeterminate_check_box_outlined, color: Colors.blue),
        Valence.yes => Icon(Icons.check_box_outlined, color: Colors.green),
        Valence.no => Icon(Icons.disabled_by_default_outlined, color: Colors.red),
        _ => Icon(Icons.check_box_outline_blank_outlined),
      },
      title: switch (value) {
        Valence.maybe => Text(AppLocalizations.of(context)!.labelNeutral, style: TextStyle(color: Colors.blue)),
        Valence.yes => Text(AppLocalizations.of(context)!.labelTrue, style: TextStyle(color: Colors.green)),
        Valence.no => Text(AppLocalizations.of(context)!.labelFalse, style: TextStyle(color: Colors.red)),
        _ => Text(AppLocalizations.of(context)!.undefined),
      },
      trailing: trailing,
    );
  }
}
