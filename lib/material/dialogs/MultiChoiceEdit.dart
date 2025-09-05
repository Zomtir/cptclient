import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class MultiChoiceEdit<T> extends StatefulWidget {
  MultiChoiceEdit({
    super.key,
    required this.items,
    required this.value,
    required this.builder,
    this.nullable = false,
  });

  final List<T> items;
  final T? value;
  final Widget Function(T) builder;
  final bool nullable;

  @override
  State<MultiChoiceEdit<T>> createState() => MultiChoiceEditState<T>();
}

class MultiChoiceEditState<T> extends State<MultiChoiceEdit<T>> {
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

    Widget radioGroup = RadioGroup<T?>(
      groupValue: value,
      onChanged: (T? v) => setState(() => value = v),
      child: Column(
        children: <Widget>[
          if (widget.nullable)
            ListTile(
              title: Text(AppLocalizations.of(context)!.undefined),
              leading: Radio<T?>(
                value: null,
              ),
            ),
          ...widget.items.map((i) =>
              ListTile(
                title: widget.builder(i),
                leading: Radio<T?>(
                  value: i,
                ),
              ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        radioGroup,
        actions
      ],
    );
  }
}
