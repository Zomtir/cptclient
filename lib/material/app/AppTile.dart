import 'package:flutter/material.dart';

class AppTile<T> extends StatelessWidget {
  final T item;
  final Function(T) onTap;
  final child;

  const AppTile({
    Key? key,
    required this.item,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item),
      child: Container(
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
      ),
    );
  }

}
