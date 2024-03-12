import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppDialog.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showTileSelector<T>({
  required BuildContext context,
  required List<T> items,
  Function(BuildContext, T)? onSelect,
  required Widget Function(T, Function(T)?) builder,
  required List<T> Function(List<T>, String) filter,
}) async {
  return showDialog<void>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return TileSelector<T>(
        items: items,
        builder: builder,
        filter: filter,
      );
    },
  );
}

class TileSelector<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T, Function(T)?) builder;
  final List<T> Function(List<T>, String) filter;

  TileSelector({
    super.key,
    required this.items,
    required this.builder,
    required this.filter,
  });

  @override
  TileSelectorState createState() => TileSelectorState<T>(available: items);
}

class TileSelectorState<T> extends State<TileSelector<T>> {
  List<T> available;

  TileSelectorState({
    required this.available,
  });

  void _handleSelect(T item) {
    setState(() {
      available.remove(item);
    });
  }

  void _handleClose() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        children: [
          AppButton(
            onPressed: _handleClose,
            text: AppLocalizations.of(context)!.actionClose,
          ),
          SearchablePanel<T>(
            items: available,
            onSelect: _handleSelect,
            filter: widget.filter,
            builder: widget.builder,
          ),
        ],
      ),
    );
  }
}
