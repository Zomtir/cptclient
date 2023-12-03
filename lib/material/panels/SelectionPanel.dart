import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/AppButton.dart';

class SelectionPanel<T> extends StatelessWidget {
  final Widget Function(T) builder;
  final List<T> available;
  final List<T> chosen;
  final Function(T) onAdd;
  final Function(T) onRemove;
  final List<T> Function(List<T>, String) filter;

  const SelectionPanel({
    Key? key,
    required this.builder,
    required this.available,
    this.chosen = const [],
    required this.onAdd,
    required this.onRemove,
    required this.filter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(text: AppLocalizations.of(context)!.actionNew, onPressed: () => showTilePicker(
          context: context,
          available: available,
          hidden: chosen,
          onSelect: onAdd,
          filter: filter,
          builder: builder,
        )),
        AppListView<T>(
          items: chosen,
          itemBuilder: (T item) {
            return Row(
              children: [
                Expanded(
                  child: builder(item),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => onRemove(item),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

}
