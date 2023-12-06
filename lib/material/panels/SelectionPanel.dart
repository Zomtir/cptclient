import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/AppButton.dart';

class SelectionPanel<T> extends StatelessWidget {
  final SelectionData<T> dataModel;
  final Widget Function(T) builder;

  const SelectionPanel({
    super.key,
    required this.dataModel,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: AppLocalizations.of(context)!.actionNew,
          onPressed: () => showTilePicker(
            context: context,
            dataModel: dataModel,
            builder: (T item) {
              return Row(
                children: [
                  Expanded(
                    child: builder(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => dataModel.onSelect(item),
                  ),
                ],
              );
            },
          ),
        ),
        AppListView<T>(
          items: dataModel.selected,
          itemBuilder: (T item) {
            return Row(
              children: [
                Expanded(
                  child: builder(item),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => dataModel.onDeselect(item),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
