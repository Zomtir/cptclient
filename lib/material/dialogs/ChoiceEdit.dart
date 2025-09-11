import 'package:cptclient/json/valence.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:flutter/material.dart';

class ChoiceEdit extends StatefulWidget {
  final Valence? value;
  final bool neutral;
  final VoidCallback? onReset;
  final Function(Valence)? onConfirm;

  ChoiceEdit({
    super.key,
    required this.value,
    this.neutral = false,
    this.onReset,
    this.onConfirm,
  });

  @override
  State<ChoiceEdit> createState() => ChoiceEditState();
}

class ChoiceEditState extends State<ChoiceEdit> {
  late Valence value;

  @override
  void initState() {
    super.initState();
    value = widget.value ?? Valence.maybe;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        children: [
          ListTile(
            leading: value == Valence.yes
                ? IconButton(icon: Icon(Icons.radio_button_checked), onPressed: null)
                : IconButton(
                    icon: Icon(Icons.radio_button_unchecked),
                    onPressed: () => setState(() => value = Valence.yes),
                  ),
            title: Text(AppLocalizations.of(context)!.labelTrue, style: TextStyle(color: Colors.green)),
          ),
          if (widget.neutral)
            ListTile(
              leading: value == Valence.maybe
                  ? IconButton(icon: Icon(Icons.radio_button_checked), onPressed: null)
                  : IconButton(
                      icon: Icon(Icons.radio_button_unchecked),
                      onPressed: () => setState(() => value = Valence.maybe),
                    ),
              title: Text(AppLocalizations.of(context)!.labelNeutral, style: TextStyle(color: Colors.blue)),
            ),
          ListTile(
            leading: value == Valence.no
                ? IconButton(icon: Icon(Icons.radio_button_checked), onPressed: null)
                : IconButton(
                    icon: Icon(Icons.radio_button_unchecked),
                    onPressed: () => setState(() => value = Valence.no),
                  ),
            title: Text(AppLocalizations.of(context)!.labelFalse, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      actions: [
        if (widget.onReset != null)
          IconButton(
            icon: const Icon(Icons.circle_outlined),
            onPressed: () {
              widget.onReset?.call();
              Navigator.pop(context);
            },
          ),
        if (widget.onConfirm != null)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onConfirm?.call(value);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
