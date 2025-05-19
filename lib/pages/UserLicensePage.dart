import 'package:cptclient/json/license.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppLicenseTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class UserLicensePage extends StatefulWidget {
  final License license;
  final Future<void> Function(License) onEdit;

  UserLicensePage({super.key, required this.license, required this.onEdit});

  @override
  UserLicensePageState createState() => UserLicensePageState();
}

class UserLicensePageState extends State<UserLicensePage> {
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlNumber = TextEditingController();
  final DateTimeController _ctrlExpiration = DateTimeController();

  UserLicensePageState();

  @override
  void initState() {
    super.initState();
    _apply();
  }

  void _apply() {
    _ctrlName.text = widget.license.name;
    _ctrlNumber.text = widget.license.number;
    _ctrlExpiration.setDateTime(widget.license.expiration);
  }

  bool _gather() {
    if (_ctrlName.text.isEmpty || _ctrlNumber.text.length > 50) {
      messageText("${AppLocalizations.of(context)!.licenseName} ${AppLocalizations.of(context)!.isInvalid}");
      return false;
    }

    if (_ctrlNumber.text.isEmpty || _ctrlNumber.text.length > 20 ) {
      messageText("${AppLocalizations.of(context)!.licenseNumber} ${AppLocalizations.of(context)!.isInvalid}");
      return false;
    }

    if (_ctrlExpiration.getDateTime() == null) {
      messageText("${AppLocalizations.of(context)!.licenseExpiration} ${AppLocalizations.of(context)!.isInvalid}");
      return false;
    }

    widget.license.name = _ctrlName.text;
    widget.license.number = _ctrlNumber.text;
    widget.license.expiration = _ctrlExpiration.getDateTime()!;

    return true;
  }

  void _submit() async {
    if (!_gather()) return;
    await widget.onEdit(widget.license);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageUserEdit),
      ),
      body: AppBody(
        children: [
          AppLicenseTile(
            license: widget.license,
          ),
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
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
