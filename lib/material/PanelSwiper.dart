import 'dart:math';

import 'package:flutter/material.dart';

class Panel {
  final String text;
  final Widget widget;

  Panel(this.text, this.widget);
}

class PanelSwiper extends StatefulWidget {
  final List<Panel> panels;
  final int swipes;
  final Function(int index)? onChange;

  PanelSwiper({super.key, required this.panels, this.swipes = 0, this.onChange}) {
    if (panels.isEmpty) throw ("SwipePanel needs at least one entry for the label and panel.");
  }

  @override
  _PanelSwiperState createState() => _PanelSwiperState();
}

class _PanelSwiperState extends State<PanelSwiper> {
  int _index = 0;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _count = widget.panels.length;
    _index = widget.swipes;
  }

  @override
  Widget build(BuildContext context) {
    int _indexPrev = (_index - 1) % _count;
    int _indexNext = (_index + 1) % _count;

    return Column(
      children: [
        Row(
          children: [
            if (_count > 1)
              IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() => _index = _indexPrev);
                  widget.onChange?.call(_index);
                },
              ),
            if (_count > 1)
              ClipPath(
                clipper: CornerClipper(left: 20, right: -20),
                child: Container(
                  height: 30,
                  width: 30,
                  color: Colors.amber,
                  child: RawMaterialButton(
                    onPressed: () {
                      setState(() => _index = _indexPrev);
                      widget.onChange?.call(_index);
                    },
                  ),
                ),
              ),
            Expanded(
              child: ClipPath(
                clipper: CornerClipper(left: 20, right: 20),
                child: Container(
                  height: 30,
                  color: Colors.amber,
                  child: Center(
                    child: Text(widget.panels[_index].text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ),
            ),
            if (_count > 1)
              ClipPath(
                clipper: CornerClipper(left: -20, right: 20),
                child: Container(
                  height: 30,
                  width: 30,
                  color: Colors.amber,
                  child: RawMaterialButton(
                    onPressed: () {
                      setState(() => _index = _indexNext);
                      widget.onChange?.call(_index);
                    },
                  ),
                ),
              ),
            if (_count > 1)
              IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {
                  setState(() => _index = _indexNext);
                  widget.onChange?.call(_index);
                },
              ),
          ],
        ),
        widget.panels[_index].widget,
      ],
    );
  }
}

class CornerClipper extends CustomClipper<Path> {
  final double left;
  final double right;

  CornerClipper({required this.left, required this.right});

  @override
  Path getClip(Size size) {
    final double leftOuter = max(left, 0);
    final double leftInner = max(-left, 0);
    final double rightOuter = size.width - max(right, 0);
    final double rightInner = size.width - max(-right, 0);

    final path = Path();
    path.moveTo(leftOuter, 0);
    path.cubicTo(leftInner, 0, leftInner, size.height, leftOuter, size.height);
    path.lineTo(rightOuter, size.height);
    path.cubicTo(rightInner, size.height, rightInner, 0, rightOuter, 0);
    path.lineTo(rightOuter, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CornerClipper oldClipper) => false;
}
