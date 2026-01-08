import 'package:flutter/material.dart';

class CollapsibleSection extends StatefulWidget {
  final List<Widget> children;
  final bool hidden;

  CollapsibleSection({required this.children, this.hidden = true});

  @override
  CollapsibleSectionState createState() => CollapsibleSectionState();
}

class CollapsibleSectionState extends State<CollapsibleSection> with SingleTickerProviderStateMixin {
  late AnimationController _ctrlAnimation;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _ctrlAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = CurvedAnimation(
      parent: _ctrlAnimation,
      curve: Curves.fastOutSlowIn,
    );
    widget.hidden ? _ctrlAnimation.reverse() : _ctrlAnimation.forward();
  }

  @override
  void didUpdateWidget(CollapsibleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.hidden ? _ctrlAnimation.reverse() : _ctrlAnimation.forward();
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
