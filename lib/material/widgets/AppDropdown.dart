import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final DropdownController<T> controller;
  final void Function(T?) onChanged;
  final Widget Function(T) builder;
  final Widget? hint;

  AppDropdown({required this.controller, required this.onChanged, required this.builder, this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<T>(
            hint: hint,
            value: controller.value,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.grey),
            isExpanded: true,
            underline: Container(
              height: 2,
              color: Colors.grey,
            ),
            onChanged: onChanged,
            items: controller.items.map<DropdownMenuItem<T>>((T t) {
              return DropdownMenuItem<T>(
                value: t,
                child: builder(t),
              );
            }).toList(),
            //selectedItemBuilder,
          ),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => onChanged(null),
        ),
      ],
    );
  }
}
