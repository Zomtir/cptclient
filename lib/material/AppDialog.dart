import 'package:flutter/material.dart';

import 'design/AppDecoration.dart';

class AppDialog extends StatelessWidget {
  final Widget child;

  const AppDialog({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Container(
              decoration: const AppDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
