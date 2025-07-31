import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  final Widget child;
  final Widget? child2;
  final Widget? leading;
  final List<Widget>? trailing;
  final VoidCallback? onTap;

  const AppTile({super.key, required this.child, this.child2, this.leading, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          title: child,
          subtitle: child2,
          leading: leading,
          trailing: trailing == null ? null : Row(children: trailing!, mainAxisSize: MainAxisSize.min),
          onTap: onTap,
        ),
      ),
    );
  }
}
