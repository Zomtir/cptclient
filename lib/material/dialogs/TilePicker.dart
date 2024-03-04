import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppDialog.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<T?> showTilePicker<T>({
  required BuildContext context,
  T? initial,
  Function(BuildContext, T)? onSelect,
  required List<T> available,
  required List<T> selected,
  required Widget Function(T) builder,
  required List<T> Function(List<T>, String) filter,
}) async {
  Widget picker = TilePicker<T>(
    initial: initial,
    onSelect: onSelect,
    available: available,
    selected: selected,
    builder: builder,
    filter: filter,
  );

  return showDialog<T>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppDialog(
        child: picker,
        //maxWidth: 470,
      );
    },
  );
}

class TilePicker<T> extends StatelessWidget {
  TilePicker({
    super.key,
    this.initial,
    this.onSelect,
    required this.available,
    required this.selected,
    required this.builder,
    required this.filter,
  });

  final T? initial;
  final Function(BuildContext, T)? onSelect;
  final List<T> available;
  final List<T> selected;
  final Widget Function(T) builder;
  final List<T> Function(List<T>, String) filter;

  void _handleConfirm(BuildContext context, T item) {
    if (onSelect == null) {
      Navigator.pop(context, item);
    } else {
      onSelect!.call(context, item);
    }
  }

  void _handleClose(BuildContext context) {
    Navigator.pop(context, this.initial);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          onPressed: () => _handleClose(context),
          text: AppLocalizations.of(context)!.actionClose,
        ),
        SearchablePanel<T>(
          dataModel: SelectionData<T>(
            available: available,
            selected: selected,
            onSelect: (item) => _handleConfirm(context, item),
            onDeselect: null,
            filter: filter,
          ),
          builder: builder,
        ),
      ],
    );
  }
}
