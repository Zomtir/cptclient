import 'package:flutter/material.dart';

class SelectController {
  bool isSelecting = false;
  int selectedIndex = -1;

  // Return selection status
  bool isSelected(int i) {
    return isSelecting && (selectedIndex == i);
  }

  // Select at index
  void select(int index) {
    isSelecting = true;
    selectedIndex = index;
  }

  // Deselect
  void deselect() {
    isSelecting = false;
    selectedIndex = -1;
  }
}

class SelectItem extends StatefulWidget {
  final Widget child;
  final VoidCallback onSelected;
  final VoidCallback onConfirmed;

  const SelectItem({
    super.key,
    required this.child,
    required this.onSelected,
    required this.onConfirmed,
  });

  @override
  _SelectItemState createState() => _SelectItemState();
}

class _SelectItemState extends State<SelectItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected();
      },
      onDoubleTap: () {
        widget.onConfirmed();
      },
      onLongPress: () {
        widget.onConfirmed();
      },

      child: widget.child,
    );
  }
}
