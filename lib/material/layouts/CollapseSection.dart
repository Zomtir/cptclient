import 'package:flutter/material.dart';

class CollapseSection extends StatefulWidget {
  final List<Widget> children;
  final bool collapse;

  CollapseSection({this.collapse = false, required this.children});

  @override
  CollapseSectionState createState() => CollapseSectionState();
}

class CollapseSectionState extends State<CollapseSection> with SingleTickerProviderStateMixin {
  late AnimationController _ctrlAnimation;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _ctrlAnimation = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    _animation = CurvedAnimation(
      parent: _ctrlAnimation,
      curve: Curves.fastOutSlowIn,
    );
    widget.collapse ? _ctrlAnimation.reverse() : _ctrlAnimation.forward();
  }

  @override
  void didUpdateWidget(CollapseSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.collapse ? _ctrlAnimation.reverse() : _ctrlAnimation.forward();
  }

  @override
  void dispose() {
    _ctrlAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: _animation,
        child: Column(children: widget.children),
    );
  }
}