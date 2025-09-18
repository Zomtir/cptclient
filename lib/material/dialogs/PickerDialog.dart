import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:flutter/material.dart';

class PickerDialog<T extends FieldInterface> extends StatelessWidget {
  final String? title;
  final List<T> items;
  final Function(T)? onPick;

  PickerDialog({
    super.key,
    this.title,
    required this.items,
    this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Text(title ?? '', textAlign: TextAlign.center),
      child: Column(
        children: [
          SearchablePanel<T>(
            items: items,
            onTap: (item) {
              onPick?.call(item);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
