import 'package:cptclient/json/license.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class LicenseEdit extends StatefulWidget {
  final License license;

  LicenseEdit({super.key, required this.license});

  @override
  LicenseEditState createState() => LicenseEditState();
}

class LicenseEditState extends State<LicenseEdit> {
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlNumber = TextEditingController();
  final DateTimeController _ctrlExpiration = DateTimeController();

  LicenseEditState();

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

  @override
  Widget build(BuildContext context) {
    final Widget actions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AppButton(
          onPressed: () => Navigator.pop(context),
          text: AppLocalizations.of(context)!.actionCancel,
        ),
        Spacer(),
        AppButton(
          onPressed: () => Navigator.pop(context, Success(null)),
          text: AppLocalizations.of(context)!.actionRemove,
        ),
        Spacer(),
        AppButton(
          onPressed: () async {
            if (!_gather()) return;
            Navigator.pop(context, Success(widget.license));
          },
          text: AppLocalizations.of(context)!.actionConfirm,
        ),
      ],
    );

    return Column(
        children: [
          widget.license.buildTile(context),
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
          actions,
        ],
      );
  }
}
