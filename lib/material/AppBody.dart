import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final List<Widget> children;
  final double maxWidth;

  const AppBody({required this.children, this.maxWidth = 600});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8.0),
          children: children,
        ),
      ),
    );
  }
}
