import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/static/server_team_admin.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    _gatherTeam();

    bool success;
    if (widget.isDraft) {
      success = await server.team_create(widget.session, widget.team) != null;
    } else {
      success = await server.team_edit(widget.session, widget.team);
    }

    if (!success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to edit team')));
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Successfully edited team')));
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
