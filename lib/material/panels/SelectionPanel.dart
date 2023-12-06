import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/AppButton.dart';

class SelectionPanel<T> extends StatefulWidget {
  final SelectionData<T> dataModel;
  final Widget Function(T) builder;

  const SelectionPanel({
    super.key,
    required this.dataModel,
    required this.builder,
  });

  @override
  SelectionPanelState createState() => SelectionPanelState<T>();
}

class SelectionPanelState<T> extends State<SelectionPanel<T>> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: AppLocalizations.of(context)!.actionNew,
          onPressed: () => showTilePicker(
            context: context,
            dataModel: widget.dataModel,
            builder: (T item) {
              return Row(
                children: [
                  Expanded(
                    child: widget.builder(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => widget.dataModel.onSelect(item),
                  ),
                ],
              );
            },
          ),
        ),
        ListenableBuilder(
          listenable: widget.dataModel,
          builder: (BuildContext context, Widget? child) {
            return AppListView<T>(
              items: widget.dataModel.selected,
              itemBuilder: (T item) {
                return Row(
                  children: [
                    Expanded(
                      child: widget.builder(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => widget.dataModel.onDeselect(item),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
