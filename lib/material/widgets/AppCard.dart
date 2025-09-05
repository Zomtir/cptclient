import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget leading;
  final List<Widget> children;
  final List<Widget>? trailing;

  const AppCard({
    super.key,
    required this.leading,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: leading,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          ...?trailing,
        ],
      ),
    );
  }
}
