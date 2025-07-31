import 'package:flutter/material.dart';

class AppTileNew extends StatelessWidget {
  final Widget child;

  const AppTileNew({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }
}
