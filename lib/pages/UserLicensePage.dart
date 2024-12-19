import 'package:cptclient/json/license.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppLicenseTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserLicensePage extends StatefulWidget {
  final License license;
  final Future<void> Function(License) onEdit;
  final Future<void> Function() onDelete;

  UserLicensePage({super.key, required this.license, required this.onEdit, required this.onDelete});

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
    _ctrlNumber.text = widget.license.number.toString();
    _ctrlExpiration.setDateTime(widget.license.expiration);
  }

  void _gather() {
    if (_ctrlName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.licenseName} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (parseNullInt(_ctrlNumber.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.licenseNumber} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (_ctrlExpiration.getDateTime() == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("${AppLocalizations.of(context)!.licenseExpiration} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    widget.license.name = _ctrlName.text;
    widget.license.number = parseNullInt(_ctrlNumber.text)!;
    widget.license.expiration = _ctrlExpiration.getDateTime()!;
  }

  void _submit() async {
    _gather();
    await widget.onEdit(widget.license);
    Navigator.pop(context);
  }

  void _handleDelete() async {
    await widget.onDelete();
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
          Row(
            children: [
              Expanded(
                child: AppLicenseTile(
                  license: widget.license,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _handleDelete,
              ),
            ],
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
            child: DateTimeEdit(
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
