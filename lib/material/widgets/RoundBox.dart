import 'package:flutter/material.dart';

class RoundBox extends StatelessWidget {
  final Widget child;

  const RoundBox({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white60,
        border: Border.all(
          color: Colors.amber,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: child,
    );
  }

}
