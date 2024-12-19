import 'package:cptclient/json/license.dart';
import 'package:cptclient/pages/UserLicensePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LicenseField extends StatelessWidget {
  final License? license;
  final Future<void> Function() onCreate;
  final Future<void> Function(License) onEdit;
  final Future<void> Function() onDelete;

  LicenseField({
    super.key,
    required this.license,
    required this.onCreate,
    required this.onEdit,
    required this.onDelete,
  });

  _handleEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserLicensePage(license: license!, onEdit: onEdit, onDelete: onDelete),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (license == null)
          ListTile(
            title: Text(AppLocalizations.of(context)!.labelMissing),
            trailing: IconButton(onPressed: onCreate, icon: Icon(Icons.add)),
          ),
        if (license != null)
          ListTile(
            title: Text("${license!.name} (${license!.number})"),
            trailing: IconButton(onPressed: () => _handleEdit(context), icon: Icon(Icons.edit)),
          ),
      ],
    );
  }
}
