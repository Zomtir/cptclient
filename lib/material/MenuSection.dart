import 'package:flutter/material.dart';

class MenuSection extends StatelessWidget {
  final String title;
  final Widget? icon;
  final List<Widget> children;

  const MenuSection({super.key, required this.title, this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: icon,
        title: Text(title),
      ),
      Card(
        child: Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: children,
          ).toList(),
        ),
      ),
    ]);
  }
}
