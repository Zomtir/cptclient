import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';

Future<void> showTileSelector<T extends FieldInterface>({
  required BuildContext context,
  required List<T> items,
  required Widget Function(T, Function(T)?) builder,
}) async {
  return showDialog<void>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return TileSelector<T>(
        items: items,
      );
    },
  );
}

class TileSelector<T extends FieldInterface> extends StatefulWidget {
  final List<T> items;

  TileSelector({
    super.key,
    required this.items,
  });

  @override
  TileSelectorState createState() => TileSelectorState<T>(available: items);
}

class TileSelectorState<T extends FieldInterface> extends State<TileSelector<T>> {
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
            onTap: (item) => _handleSelect(item),
          ),
        ],
      ),
    );
  }
}
