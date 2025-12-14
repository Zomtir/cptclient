import 'package:cptclient/api/admin/location/location.dart' as api_admin;
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class LocationCreatePage extends StatefulWidget {
  final UserSession session;

  LocationCreatePage({super.key, required this.session});

  @override
  LocationCreatePageState createState() => LocationCreatePageState();
}

class LocationCreatePageState extends State<LocationCreatePage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();

  LocationCreatePageState();

  @override
  void initState() {
    super.initState();
    Location location = Location.fromVoid();
    _ctrlKey.text = location.key;
    _ctrlName.text = location.name;
    _ctrlDescription.text = location.description;
  }

  void _submit() async {
    if (_ctrlKey.text.isEmpty) {
      messageText("${AppLocalizations.of(context)!.locationKey} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (_ctrlName.text.isEmpty) {
      messageText("${AppLocalizations.of(context)!.locationName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    Location location = Location.fromVoid();
    location.key = _ctrlKey.text;
    location.name = _ctrlName.text;
    location.description = _ctrlDescription.text;

    var result = await api_admin.location_create(widget.session, location);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageLocationEdit),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.locationKey,
            child: TextField(maxLines: 1, controller: _ctrlKey),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.locationName,
            child: TextField(maxLines: 1, controller: _ctrlName),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.locationDescription,
            child: TextField(maxLines: 1, controller: _ctrlDescription),
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
