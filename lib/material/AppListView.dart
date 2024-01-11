import 'package:flutter/material.dart';

class AppListView<T> extends StatelessWidget {
  const AppListView({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  final List<T>? items;
  final Widget Function(T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (items == null) return Container();
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: items!.length,
      itemBuilder: (context, index) {
        return itemBuilder(items![index]);
      },
    );
  }
}