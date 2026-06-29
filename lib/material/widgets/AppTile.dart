import 'package:cptclient/material/widgets/RoundTile.dart';
import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  final Widget child;
  final Widget? leading;
  final List<Widget>? trailing;
  final VoidCallback? onTap;

  const AppTile({super.key, required this.child, this.leading, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: RoundTile(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: leading,
            ),
            Expanded(
              child: child,
            ),
            ...?trailing,
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
