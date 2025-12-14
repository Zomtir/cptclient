import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  final Widget child;
  final Widget? leading;
  final List<Widget>? trailing;
  final VoidCallback? onTap;

  const AppTile({super.key, required this.child, this.leading, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: child,
          leading: leading,
          trailing: trailing == null ? null : Row(mainAxisSize: MainAxisSize.min, children: trailing!),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        ),
      ),
    );
  }
}
