import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectionPanel<T> extends StatelessWidget {
  final List<T> available;
  final List<T> selected;
  final Function(T)? onSelect;
  final Function(T)? onDeselect;
  final List<T> Function(List<T>, String) filter;
  final Widget Function(T) builder;

  const SelectionPanel({
    super.key,
    required this.available,
    required this.selected,
    this.onSelect,
    this.onDeselect,
    required this.filter,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: AppLocalizations.of(context)!.actionAdd,
          onPressed: () => showTilePicker<T>(
            context: context,
            available: this.available,
            selected: this.selected,
            filter: this.filter,
            builder: (T item) {
              return Row(
                children: [
                  Expanded(
                    child: this.builder(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => this.onSelect?.call(item),
                  ),
                ],
              );
            },
            onSelect: (BuildContext context, T item) => this.onSelect?.call(item),
          ),
        ),
        AppListView<T>(
          items: this.selected,
          itemBuilder: (T item) {
            return Row(
              children: [
                Expanded(
                  child: this.builder(item),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => this.onDeselect?.call(item),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
