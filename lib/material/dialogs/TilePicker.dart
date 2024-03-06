import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppDialog.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<T?> showTilePicker<T>({
  required BuildContext context,
  required List<T> items,
  required Widget Function(T) builder,
  required List<T> Function(List<T>, String) filter,
}) async {
  return showDialog<T>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppDialog(
        child: Column(
          children: [
            AppButton(
              onPressed: () => Navigator.pop(context, null),
              text: AppLocalizations.of(context)!.actionClose,
            ),
            SearchablePanel<T>(
              items: items,
              onSelect: (item) => Navigator.pop(context, item),
              filter: filter,
              builder: (item, Function(T)? onSelect) => InkWell(
                onTap: () => onSelect?.call(item),
                child: builder(item),
              ),
            ),
          ],
        ),
      );
    },
  );
}
