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

class LocationDetailPage extends StatefulWidget {
  final UserSession session;
  final Location location;

  LocationDetailPage({super.key, required this.session, required this.location});

  @override
  LocationDetailPageState createState() => LocationDetailPageState();
}

class LocationDetailPageState extends State<LocationDetailPage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();

  LocationDetailPageState();

  void _handleSubmit() async {

    if (widget.location.key.isEmpty) {
      messageText("${AppLocalizations.of(context)!.locationKey} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (widget.location.name.isEmpty) {
      messageText("${AppLocalizations.of(context)!.locationName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    var result = await api_admin.location_edit(widget.session, widget.location);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  void _handleDelete() async {
    var result = await api_admin.location_delete(widget.session, widget.location);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageLocationEdit),
        actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            ),
        ],
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
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
