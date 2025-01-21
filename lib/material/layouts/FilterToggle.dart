import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/CollapseSection.dart';
import 'package:flutter/material.dart';

class FilterToggle extends StatefulWidget {
  final List<Widget> children;
  final VoidCallback? onApply;
  final bool hidden;

  FilterToggle({required this.children, required this.onApply, this.hidden = true});

  @override
  FilterToggleState createState() => FilterToggleState();
}

class FilterToggleState extends State<FilterToggle> {
  bool _hideFilters = true;

  @override
  void initState() {
    super.initState();
    _hideFilters = widget.hidden;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (_hideFilters) Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.keyboard_arrow_down),
                label: Text("${AppLocalizations.of(context)!.labelFilter} ${AppLocalizations.of(context)!.actionShow}"),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() => _hideFilters = false);
                },
              ),
            ),
            if (!_hideFilters) Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.keyboard_arrow_up),
                label: Text("${AppLocalizations.of(context)!.labelFilter} ${AppLocalizations.of(context)!.actionHide}"),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() => _hideFilters = true);},
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.actionApply),
              onPressed: widget.onApply,
            ),
          ],
        ),
        CollapseSection(
          collapse: _hideFilters,
          children: widget.children,
        ),
      ],
    );
  }
}
