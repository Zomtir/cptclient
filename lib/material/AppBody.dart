import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final List<Widget> children;

  const AppBody({required this.children});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8.0),
          children: children,
        ),
      ),
    );
  }
}
