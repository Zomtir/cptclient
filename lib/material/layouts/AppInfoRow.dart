import 'package:flutter/material.dart';

class AppInfoRow extends StatelessWidget {
  final String info;
  final Widget child;
  final List<Widget> leading;
  final List<Widget> trailing;

  const AppInfoRow({
    super.key,
    required this.info,
    required this.child,
    this.leading = const [],
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 3.0),
          child: Container(
            padding: EdgeInsets.only(top: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ...leading,
                  Expanded(child: child),
                  ...trailing,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 10.0,
          top: 0.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Text(
              info,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}