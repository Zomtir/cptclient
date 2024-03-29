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
  final Session session;
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
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();

  bool _ctrlRightCourse = false;
  bool _ctrlRightEvent = false;
  bool _ctrlRightInventory = false;
  bool _ctrlRightRanking = false;
  bool _ctrlRightTeam = false;
  bool _ctrlRightTerm = false;
  bool _ctrlRightUser = false;

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
    _ctrlName.text = widget.team.name;
    _ctrlDescription.text = widget.team.description;
    _ctrlRightCourse = widget.team.right!.admin_courses;
    _ctrlRightEvent = widget.team.right!.admin_courses;
    _ctrlRightInventory = widget.team.right!.admin_inventory;
    _ctrlRightRanking = widget.team.right!.admin_competence;
    _ctrlRightTeam = widget.team.right!.admin_teams;
    _ctrlRightTerm = widget.team.right!.admin_term;
    _ctrlRightUser = widget.team.right!.admin_users;
  }

  void _gatherTeam() {
    widget.team.name = _ctrlName.text;
    widget.team.description = _ctrlDescription.text;
    widget.team.right!.admin_courses = _ctrlRightCourse;
    widget.team.right!.admin_competence = _ctrlRightRanking;
    widget.team.right!.admin_event = _ctrlRightEvent;
    widget.team.right!.admin_inventory = _ctrlRightInventory;
    widget.team.right!.admin_teams = _ctrlRightTeam;
    widget.team.right!.admin_term = _ctrlRightTerm;
    widget.team.right!.admin_users = _ctrlRightUser;
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
          _buildEditPanel(),
        ],
      ),
    );
  }

  Widget _buildEditPanel() {
    return Column(
      children: [
        AppInfoRow(
          info: Text("Name"),
          child: TextField(
            maxLines: 1,
            controller: _ctrlName,
          ),
        ),
        AppInfoRow(
          info: Text("Description"),
          child: TextField(
            maxLines: 1,
            controller: _ctrlDescription,
          ),
        ),
        AppInfoRow(
          info: Text("Course Edit"),
          child: Checkbox(
            value: _ctrlRightCourse,
            onChanged: (bool? enabled) =>
                setState(() => _ctrlRightCourse = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Event Edit"),
          child: Checkbox(
            value: _ctrlRightEvent,
            onChanged: (bool? enabled) =>
                setState(() => _ctrlRightEvent = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Inventory Edit"),
          child: Checkbox(
            value: _ctrlRightInventory,
            onChanged: (bool? enabled) =>
                setState(() => _ctrlRightInventory = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Ranking Edit"),
          child: Checkbox(
            value: _ctrlRightRanking,
            onChanged: (bool? enabled) =>
                setState(() => _ctrlRightRanking = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Team Edit"),
          child: Checkbox(
            value: _ctrlRightTeam,
            onChanged: (bool? enabled) =>
                setState(() => _ctrlRightTeam = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Term Edit"),
          child: Checkbox(
            value: _ctrlRightTerm,
            onChanged: (bool? enabled) =>
                setState(() => _ctrlRightTerm = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("User Edit"),
          child: Checkbox(
            value: _ctrlRightUser,
            onChanged: (bool? enabled) =>
                setState(() => _ctrlRightUser = enabled!),
          ),
        ),
        AppButton(
          text: AppLocalizations.of(context)!.actionSave,
          onPressed: _submitTeam,
        ),
      ],
    );
  }
}
