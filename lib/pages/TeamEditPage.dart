import 'package:cptclient/api/admin/team/team.dart' as server;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class TeamEditPage extends StatefulWidget {
  final UserSession session;
  final Team team;
  final bool isDraft;

  TeamEditPage(
      {super.key,
      required this.session,
      required this.team,
      required this.isDraft});

  @override
  TeamEditPageState createState() => TeamEditPageState();
}

class TeamEditPageState extends State<TeamEditPage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();

  TeamEditPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _applyTeam();
  }

  void _applyTeam() {
    _ctrlKey.text = widget.team.key;
    _ctrlName.text = widget.team.name;
    _ctrlDescription.text = widget.team.description;
  }

  void _gatherTeam() {
    widget.team.key = _ctrlKey.text;
    widget.team.name = _ctrlName.text;
    widget.team.description = _ctrlDescription.text;
  }

  void _submitTeam() async {
    if (_ctrlKey.text.isEmpty || _ctrlKey.text.length > 10) {
      messageText("${AppLocalizations.of(context)!.teamKey} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    if (_ctrlName.text.isEmpty || _ctrlName.text.length > 30) {
      messageText("${AppLocalizations.of(context)!.teamName} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    if (_ctrlDescription.text.isEmpty || _ctrlDescription.text.length > 100) {
      messageText("${AppLocalizations.of(context)!.teamDescription} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    _gatherTeam();

    bool success;
    if (widget.isDraft) {
      success = await server.team_create(widget.session, widget.team) != null;
    } else {
      success = await server.team_edit(widget.session, widget.team);
    }

    messageFailureOnly(success);
    if (!success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTeamEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft) AppTeamTile(team: widget.team),
          if (!widget.isDraft) Divider(),
          AppInfoRow(
            info: AppLocalizations.of(context)!.teamKey,
            child: TextField(
              maxLines: 1,
              controller: _ctrlKey,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.teamName,
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.teamDescription,
            child: TextField(
              maxLines: 1,
              controller: _ctrlDescription,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _submitTeam,
          ),
        ],
      ),
    );
  }
}
