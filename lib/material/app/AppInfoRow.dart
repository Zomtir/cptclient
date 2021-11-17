import 'package:flutter/material.dart';

class AppInfoRow<T> extends StatelessWidget {
  final Widget info;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;

  AppInfoRow({required this.info, required this.child, this.leading, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 130,
          height: 48,
          alignment: Alignment.centerLeft,
          child: info,
        ),
        if (leading != null) leading!,
        Expanded(
          child: child,
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}