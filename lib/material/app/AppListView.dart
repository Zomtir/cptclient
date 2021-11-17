import 'package:flutter/material.dart';

class AppListView<T> extends StatelessWidget {
  const AppListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  final List<T> items;
  final Widget Function(T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(items[index]);
      },
    );
  }
}