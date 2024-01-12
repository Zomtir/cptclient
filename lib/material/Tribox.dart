import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Tribox extends StatelessWidget {
  final bool? value;
  final void Function(bool?) onChanged;

  const Tribox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (value) {
      case null:
        return Row(
          children: [
            IconButton(onPressed: () => onChanged(true), icon: Icon(Icons.check_box_outline_blank)),
            Text(AppLocalizations.of(context)!.actionNone)
          ],
        );
      case true:
        return Row(
          children: [
            IconButton(onPressed: () => onChanged(false), icon: Icon(Icons.check_box_outlined)),
            Text(AppLocalizations.of(context)!.actionOn)
          ],
        );
      case false:
        return Row(
          children: [
            IconButton(onPressed: () => onChanged(null), icon: Icon(Icons.disabled_by_default_outlined)),
            Text(AppLocalizations.of(context)!.actionOff)
          ],
        );
    }
    throw Exception("Tribox: Not all trinary states were covered.") ;
  }

}
