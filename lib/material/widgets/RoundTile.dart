import 'package:flutter/material.dart';

class RoundTile extends StatelessWidget {
  final Widget child;

  const RoundTile({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
