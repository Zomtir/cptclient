import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ChoiceDisplayWidget extends StatelessWidget {
  ChoiceDisplayWidget({
    super.key,
    required this.enabled,
    required this.value,
    this.trailing,
  });

  final bool enabled;
  final bool? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: switch ((enabled, value)) {
        (false, _) => Icon(Icons.check_box_outline_blank_outlined),
        (true, null) => Icon(Icons.indeterminate_check_box_outlined, color: Colors.blue),
        (true, true) => Icon(Icons.check_box_outlined, color: Colors.green),
        (true, false) => Icon(Icons.disabled_by_default_outlined, color: Colors.red),
      },
      title: switch ((enabled, value)) {
        (false, _) => Text(AppLocalizations.of(context)!.undefined),
        (true, null) => Text(AppLocalizations.of(context)!.labelNeutral, style: TextStyle(color: Colors.blue)),
        (true, true) => Text(AppLocalizations.of(context)!.labelTrue, style: TextStyle(color: Colors.green)),
        (true, false) => Text(AppLocalizations.of(context)!.labelFalse, style: TextStyle(color: Colors.red)),
      },
      trailing: trailing,
    );
  }
}

class ChoiceEditWidget extends StatefulWidget {
  ChoiceEditWidget({
    super.key,
    required this.enabled,
    required this.value,
    this.nullable = false,
    this.neutral = false,
  });

  final bool enabled;
  final bool? value;
  final bool nullable;
  final bool neutral;

  @override
  State<ChoiceEditWidget> createState() => ChoiceEditWidgetState();
}

class ChoiceEditWidgetState extends State<ChoiceEditWidget> {
  late bool enabled;
  late bool? value;

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;
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
          onPressed: () => Navigator.pop(context, Success((enabled, value))),
          text: AppLocalizations.of(context)!.actionConfirm,
        ),
      ],
    );

    if (widget.nullable && !enabled) {
      return Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.check_box_outline_blank_outlined),
              onPressed: () => setState(() => enabled = true),
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
            leading: IconButton(icon: Icon(Icons.check_box_outlined), onPressed: () => setState(() => enabled = false)),
            title: Text(AppLocalizations.of(context)!.defined),
          ),
        ListTile(
          leading: value == true
              ? IconButton(icon: Icon(Icons.radio_button_checked), onPressed: null)
              : IconButton(icon: Icon(Icons.radio_button_unchecked), onPressed: () => setState(() => value = true)),
          title: Text(AppLocalizations.of(context)!.labelTrue, style: TextStyle(color: Colors.green)),
        ),
        if (widget.neutral)
          ListTile(
            leading: value == null
                ? IconButton(icon: Icon(Icons.radio_button_checked), onPressed: null)
                : IconButton(icon: Icon(Icons.radio_button_unchecked), onPressed: () => setState(() => value = null)),
            title: Text(AppLocalizations.of(context)!.labelNeutral, style: TextStyle(color: Colors.blue)),
          ),
        ListTile(
          leading: value == false
              ? IconButton(icon: Icon(Icons.radio_button_checked), onPressed: null)
              : IconButton(icon: Icon(Icons.radio_button_unchecked), onPressed: () => setState(() => value = false)),
          title: Text(AppLocalizations.of(context)!.labelFalse, style: TextStyle(color: Colors.red)),
        ),
        actions,
      ],
    );
  }
}
