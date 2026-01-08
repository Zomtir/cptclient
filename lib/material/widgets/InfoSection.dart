import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final Widget? icon;
  final List<Widget>? actions;

  const InfoSection({super.key, required this.title, this.icon, this.actions});

  @override
  Widget build(BuildContext context) {
    return
      ListTile(
        leading: icon,
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: actions ?? const [],
        ),
      );
  }
}
