import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/CollapsibleSection.dart';
import 'package:flutter/material.dart';

class FilterToggle extends StatefulWidget {
  final List<Widget> children;
  final VoidCallback onApply;
  final bool hidden;

  FilterToggle({required this.children, required this.onApply, this.hidden = true});

  @override
  State<StatefulWidget> createState() => FilterToggleState();
}

class FilterToggleState extends State<FilterToggle> {
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    _hidden = widget.hidden;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.tune),
            Expanded(
              child: _hidden
                  ? TextButton.icon(
                      icon: Icon(Icons.keyboard_arrow_down),
                      label: Text(
                          "${AppLocalizations.of(context)!.labelFilter} ${AppLocalizations.of(context)!.actionShow}"),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() => _hidden = false);
                      },
                    )
                  : TextButton.icon(
                      icon: Icon(Icons.keyboard_arrow_up),
                      label: Text(
                          "${AppLocalizations.of(context)!.labelFilter} ${AppLocalizations.of(context)!.actionHide}"),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() => _hidden = true);
                      },
                    ),
            ),
            TextButton.icon(
              icon: Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.actionApply),
              onPressed: widget.onApply,
            ),
          ],
        ),
        CollapsibleSection(
          hidden: _hidden,
          children: widget.children,
        ),
      ],
    );
  }
}
