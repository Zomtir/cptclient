import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/AppDialog.dart';

void showTilePicker<T>({
  required BuildContext context,
  required List<T> available,
  List<T> hidden = const [],
  required Function(T) onSelect,
  required List<T> Function(List<T>, String) filter,
  required Widget Function(T) builder,
}) async {
  return showDialog(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppDialog(
        child: Column(
          children: [
            AppButton(text: AppLocalizations.of(context)!.actionClose, onPressed: () => Navigator.pop(context),),
            SearchablePanel(
              available: List<T>.from(available.toSet().difference(hidden.toSet())),
              onSelect: onSelect,
              filter: filter,
              builder: builder,
            )
          ],
        ),
      );
    },
  );
}

