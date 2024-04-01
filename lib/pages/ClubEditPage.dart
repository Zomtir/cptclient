import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/static/server_club_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubEditPage extends StatefulWidget {
  final Session session;
  final Club club;
  final void Function() onUpdate;
  final bool isDraft;

  ClubEditPage(
      {super.key,
      required this.session,
      required this.club,
      required this.onUpdate,
      required this.isDraft});

  @override
  ClubEditPageState createState() => ClubEditPageState();
}

class ClubEditPageState extends State<ClubEditPage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();

  ClubEditPageState();

  @override
  void initState() {
    super.initState();
    _applyInfo();
  }

  void _applyInfo() {
    _ctrlKey.text = widget.club.key;
    _ctrlName.text = widget.club.name;
    _ctrlDescription.text = widget.club.description;
  }

  void _gatherInfo() {
    widget.club.key = _ctrlKey.text;
    widget.club.name = _ctrlName.text;
    widget.club.description = _ctrlDescription.text;
  }

  void _handleSubmit() async {
    _gatherInfo();

    if (widget.club.key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${AppLocalizations.of(context)!.clubKey} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (widget.club.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${AppLocalizations.of(context)!.clubName} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.club_create(widget.session, widget.club)
        : await api_admin.club_edit(widget.session, widget.club);

    if (!success) return;

    widget.onUpdate();
    Navigator.pop(context);
  }

  void _deleteUser() async {
    if (!await api_admin.club_delete(widget.session, widget.club)) return;

    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            Row(
              children: [
                Expanded(
                  child: AppClubTile(club: widget.club),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteUser,
                ),
              ],
            ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.clubKey),
            child: TextField(
              maxLines: 1,
              controller: _ctrlKey,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.clubName),
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.clubDescription),
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
