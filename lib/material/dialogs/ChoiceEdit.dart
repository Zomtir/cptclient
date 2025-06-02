import 'package:cptclient/json/valence.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ChoiceEdit extends StatefulWidget {
  ChoiceEdit({
    super.key,
    required this.value,
    this.nullable = false,
    this.neutral = false,
  });

  final Valence? value;
  final bool nullable;
  final bool neutral;

  @override
  State<ChoiceEdit> createState() => ChoiceEditState();
}

class ChoiceEditState extends State<ChoiceEdit> {
  late Valence? value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    Widget actions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AppButton(
          onPressed: () => Navigator.pop(context),
          text: AppLocalizations.of(context)!.actionCancel,
        ),
        Spacer(),
        AppButton(
          onPressed: () => Navigator.pop(context, Success(value)),
          text: AppLocalizations.of(context)!.actionConfirm,
        ),
      ],
    );

    if (widget.nullable && value == null) {
      return Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.check_box_outline_blank_outlined),
              onPressed: () => setState(() => value = Valence.yes),
            ),
            title: Text(AppLocalizations.of(context)!.undefined),
          ),
          actions,
        ],
      );
    }

    return Column(
      children: [
        if (widget.nullable)
          ListTile(
            leading: IconButton(icon: Icon(Icons.check_box_outlined), onPressed: () => setState(() => value = null)),
            title: Text(AppLocalizations.of(context)!.defined),
          ),
        ListTile(
          leading: value == Valence.yes
              ? IconButton(icon: Icon(Icons.radio_button_checked), onPressed: null)
              : IconButton(icon: Icon(Icons.radio_button_unchecked), onPressed: () => setState(() => value = Valence.yes)),
          title: Text(AppLocalizations.of(context)!.labelTrue, style: TextStyle(color: Colors.green)),
        ),
        if (widget.neutral)
          ListTile(
            leading: value == Valence.maybe
                ? IconButton(icon: Icon(Icons.radio_button_checked), onPressed: null)
                : IconButton(icon: Icon(Icons.radio_button_unchecked), onPressed: () => setState(() => value = Valence.maybe)),
            title: Text(AppLocalizations.of(context)!.labelNeutral, style: TextStyle(color: Colors.blue)),
          ),
        ListTile(
          leading: value == Valence.no
              ? IconButton(icon: Icon(Icons.radio_button_checked), onPressed: null)
              : IconButton(icon: Icon(Icons.radio_button_unchecked), onPressed: () => setState(() => value = Valence.no)),
          title: Text(AppLocalizations.of(context)!.labelFalse, style: TextStyle(color: Colors.red)),
        ),
        actions,
      ],
    );
  }
}
