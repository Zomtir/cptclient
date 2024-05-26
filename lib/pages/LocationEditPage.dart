import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppLocationTile.dart';
import 'package:cptclient/static/server_location_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationEditPage extends StatefulWidget {
  final Session session;
  final Location location;
  final bool isDraft;

  LocationEditPage(
      {super.key, required this.session, required this.location, required this.isDraft});

  @override
  LocationEditPageState createState() => LocationEditPageState();
}

class LocationEditPageState extends State<LocationEditPage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();

  LocationEditPageState();

  @override
  void initState() {
    super.initState();
    _applyInfo();
  }

  void _applyInfo() {
    _ctrlKey.text = widget.location.key;
    _ctrlName.text = widget.location.name;
    _ctrlDescription.text = widget.location.description;
  }

  void _gatherInfo() {
    widget.location.key = _ctrlKey.text;
    widget.location.name = _ctrlName.text;
    widget.location.description = _ctrlDescription.text;
  }

  void _handleSubmit() async {
    _gatherInfo();

    if (widget.location.key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.locationKey} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (widget.location.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.locationName} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.location_create(widget.session, widget.location)
        : await api_admin.location_edit(widget.session, widget.location);

    if (!success) return;

    Navigator.pop(context);
  }

  void _deleteUser() async {
    if (!await api_admin.location_delete(widget.session, widget.location)) return;

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
          if (!widget.isDraft)
            AppLocationTile(
              location: widget.location,
              trailing: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteUser,
                ),
              ],
            ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.locationKey),
            child: TextField(
              maxLines: 1,
              controller: _ctrlKey,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.locationName),
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.locationDescription),
            child: TextField(
              maxLines: 1,
              controller: _ctrlDescription,
            ),
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
