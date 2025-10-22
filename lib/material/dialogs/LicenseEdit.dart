import 'package:cptclient/json/license.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class LicenseEdit extends StatefulWidget {
  final License initialValue;
  final VoidCallback? onDelete;
  final Function(License)? onConfirm;

  LicenseEdit({super.key, required this.initialValue, this.onDelete, this.onConfirm});

  @override
  LicenseEditState createState() => LicenseEditState();
}

class LicenseEditState extends State<LicenseEdit> {
  late License currentValue;
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlNumber = TextEditingController();
  final DateTimeController _ctrlExpiration = DateTimeController();

  LicenseEditState();

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    _ctrlName.text = currentValue.name;
    _ctrlNumber.text = currentValue.number;
    _ctrlExpiration.setDateTime(currentValue.expiration);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
          children: [
            AppInfoRow(
              info: AppLocalizations.of(context)!.licenseName,
              child: TextField(
                maxLines: 1,
                controller: _ctrlName,
              ),
            ),
            AppInfoRow(
              info: AppLocalizations.of(context)!.licenseNumber,
              child: TextField(
                maxLines: 1,
                controller: _ctrlNumber,
              ),
            ),
            AppInfoRow(
              info: AppLocalizations.of(context)!.licenseExpiration,
              child: DateTimeField(
                nullable: false,
                showTime: false,
                controller: _ctrlExpiration,
              ),
            ),
          ],
        ),
      actions: [
        if (widget.onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete?.call();
              Navigator.pop(context);
            },
          ),
        if (widget.onConfirm != null)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_ctrlName.text.isEmpty || _ctrlNumber.text.length > 50) {
                messageText("${AppLocalizations.of(context)!.licenseName} ${AppLocalizations.of(context)!.statusIsInvalid}");
                return;
              }

              if (_ctrlNumber.text.isEmpty || _ctrlNumber.text.length > 20 ) {
                messageText("${AppLocalizations.of(context)!.licenseNumber} ${AppLocalizations.of(context)!.statusIsInvalid}");
                return;
              }

              if (_ctrlExpiration.getDateTime() == null) {
                messageText("${AppLocalizations.of(context)!.licenseExpiration} ${AppLocalizations.of(context)!.statusIsInvalid}");
                return;
              }

              currentValue.name = _ctrlName.text;
              currentValue.number = _ctrlNumber.text;
              currentValue.expiration = _ctrlExpiration.getDateTime()!;

              widget.onConfirm?.call(currentValue);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
