import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:flutter/material.dart';

class FilterDialog<T extends FieldInterface> extends StatefulWidget {
  final String title;
  final List<T> items;
  final Function(List<(T, bool)>)? onConfirm;

  FilterDialog({
    super.key,
    required this.title,
    required this.items,
    this.onConfirm,
  });

  @override
  State<FilterDialog<T>> createState() => FilterDialogState<T>();
}

class FilterDialogState<T extends FieldInterface> extends State<FilterDialog<T>> {
  late Map<T, bool?> values = {
    for (var i in widget.items) i: null,
  };

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Text(widget.title, textAlign: TextAlign.center),
      child: Column(
        children: [
          SearchablePanel<T>(
            items: widget.items,
            actionBuilder: (BuildContext context, T item) => [
              IconButton(
                icon: const Icon(Icons.circle_outlined),
                color: Theme.of(context).disabledColor,
                disabledColor: Colors.black87,
                onPressed: values[item] == null
                    ? null
                    : () {
                        setState(() {
                          values[item] = null;
                        });
                      },
              ),
              IconButton(
                icon: const Icon(Icons.block),
                color: Theme.of(context).disabledColor,
                disabledColor: Colors.black87,
                onPressed: values[item] == false
                    ? null
                    : () {
                        setState(() {
                          values[item] = false;
                        });
                      },
              ),
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                color: Theme.of(context).disabledColor,
                disabledColor: Colors.black87,
                onPressed: values[item] == true
                    ? null
                    : () {
                        setState(() {
                          values[item] = true;
                        });
                      },
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (widget.onConfirm != null)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              List<(T, bool)> list = values.entries
                  .where((e) => e.value != null)
                  .map((e) => (e.key, e.value!))
                  .toList();
              widget.onConfirm?.call(list);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
