import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class MultiChoiceEdit<T extends FieldInterface> extends StatefulWidget {
  MultiChoiceEdit({
    super.key,
    required this.items,
    required this.value,
    this.nullable = false,
  });

  final List<T> items;
  final T? value;
  final bool nullable;

  @override
  State<MultiChoiceEdit<T>> createState() => MultiChoiceEditState<T>();
}

class MultiChoiceEditState<T extends FieldInterface> extends State<MultiChoiceEdit<T>> {
  late T? value;

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
          onPressed: () => Navigator.pop(context, Success<T?>(value)),
          text: AppLocalizations.of(context)!.actionConfirm,
        ),
      ],
    );

    return Column(
      children: [
        if (widget.nullable)
          ListTile(
            title: Text(AppLocalizations.of(context)!.undefined),
            leading: Radio<T?>(
              value: null,
              groupValue: value,
              onChanged: (T? v) => setState(() => value = v),
            ),
          ),
        ...widget.items.map((i) =>
            ListTile(
              title: i.buildEntry(context),
              leading: Radio<T?>(
                value: i,
                groupValue: value,
                onChanged: (T? v) => setState(() => value = v),
              ),
            ),
        ),
        actions,
      ],
    );
  }
}
