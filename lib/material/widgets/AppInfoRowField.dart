import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppInfoRow.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class AppInfoRowField<T extends FieldInterface> extends StatelessWidget {
  final String info;
  final T? element;
  final Future<Result<List<T>>> Function() callElements;
  final Function(T?) onChanged;
  final bool nullable;

  const AppInfoRowField({super.key, required this.info, required this.element, required this.callElements, required this.onChanged, required this.nullable});

  @override
  Widget build(BuildContext context) {
    return AppInfoRow(
      info: info,
      child: element?.buildEntry(context) ?? Text(''),
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            var result = await callElements();
            if (result is! Success) return;
            var elements = result.unwrap();
            elements.sort();
            await showDialog(
              context: context,
              builder: (context) => PickerDialog(
                items: elements,
                onPick: onChanged,
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => onChanged.call(null),
        ),
      ],
    );
  }
}
