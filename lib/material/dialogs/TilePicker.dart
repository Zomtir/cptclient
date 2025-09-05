import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';

Future<T?> showTilePicker<T extends FieldInterface>({
  required BuildContext context,
  required List<T> items,
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
              onTap: (item) => Navigator.pop(context, item),
            ),
          ],
        ),
      );
    },
  );
}
