import 'package:cptclient/material/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final List<Widget> children;
  final double minWidth;
  final double maxWidth;
  final bool locked;

  const AppBody({required this.children, this.minWidth = 0, this.maxWidth = 600, this.locked = false});

  @override
  Widget build(BuildContext context) {
    if (locked) return LoadingWidget();
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
      
          final child = ListView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8.0),
            children: children,
          );
      
          if (screenWidth > minWidth) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: child,
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: minWidth,
                child: child,
              ),
            );
          }
        },
      ),
    );
  }
}
