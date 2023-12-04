import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'CollapseWidget.dart';

class FilterToggle extends StatefulWidget {
  final List<Widget> children;

  FilterToggle({required this.children});

  @override
  FilterToggleState createState() => FilterToggleState();
}

class FilterToggleState extends State<FilterToggle> {
  bool _hideFilters = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          icon: _hideFilters ? Icon(Icons.keyboard_arrow_down) : Icon(Icons.keyboard_arrow_up),
          label: _hideFilters ? Text(AppLocalizations.of(context)!.actionShowFilter) : Text(AppLocalizations.of(context)!.actionHideFilter),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() => _hideFilters = !_hideFilters);},
        ),
        CollapseWidget(
          collapse: _hideFilters,
          children: widget.children,
        ),
      ],
    );
  }
}
