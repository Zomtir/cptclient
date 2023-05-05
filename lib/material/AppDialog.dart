import 'package:flutter/material.dart';

import 'design/AppBoxDecoration.dart';

class AppDialog extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AppDialog({required this.child, this.maxWidth = 600});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.3),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                decoration: const AppBoxDecoration(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                margin: const EdgeInsets.all(5.0),
                child: child,
              )
            ],
          ),
        ),
      ),
    );
  }
}
