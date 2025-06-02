import 'package:cptclient/material/layouts/CollapsibleSection.dart';
import 'package:flutter/material.dart';

class SectionToggle extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool hidden;

  SectionToggle({required this.title, required this.children, this.hidden = true});

  @override
  State<StatefulWidget> createState() => SectionToggleState();
}

class SectionToggleState extends State<SectionToggle> {
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
        ListTile(
          title: Text(widget.title),
          leading: _hidden ? Icon(Icons.keyboard_arrow_down) : Icon(Icons.keyboard_arrow_up),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() => _hidden = !_hidden);
          },
        ),
        CollapsibleSection(
          hidden: _hidden,
          children: widget.children,
        ),
      ],
    );
  }
}
