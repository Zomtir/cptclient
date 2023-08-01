import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';

import '../material/PanelSwiper.dart';
import '../material/panels/SelectionPanel.dart';
import '../material/tiles/AppUserTile.dart';
import '../static/serverUserMember.dart' as server;
import '../static/serverTeamAdmin.dart' as server;
import '../json/session.dart';
import '../json/team.dart';
import '../json/user.dart';

class TeamAdminPage extends StatefulWidget {
  final Session session;
  final Team team;
  final bool isDraft;

  TeamAdminPage({Key? key, required this.session, required this.team, required this.isDraft}) : super(key: key);

  @override
  TeamAdminPageState createState() => TeamAdminPageState();
}

class TeamAdminPageState extends State<TeamAdminPage> {
  List<User> _memberPool = [];
  List<User> _memberList = [];

  TextEditingController _ctrlName = TextEditingController();
  TextEditingController _ctrlDescription = TextEditingController();

  bool _ctrlRightCourse = false;
  bool _ctrlRightEvent = false;
  bool _ctrlRightInventory = false;
  bool _ctrlRightRanking = false;
  bool _ctrlRightTeam = false;
  bool _ctrlRightTerm = false;
  bool _ctrlRightUser = false;

  TeamAdminPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    if (!widget.isDraft) _getTeamMemberPool();
    if (!widget.isDraft) _getTeamMemberList();
    _applyTeam();
  }

  void _applyTeam() {
    _ctrlName.text = widget.team.name;
    _ctrlDescription.text = widget.team.description;
    _ctrlRightCourse = widget.team.right!.admin_courses;
    _ctrlRightEvent = widget.team.right!.admin_courses;
    _ctrlRightInventory = widget.team.right!.admin_inventory;
    _ctrlRightRanking = widget.team.right!.admin_rankings;
    _ctrlRightTeam = widget.team.right!.admin_teams;
    _ctrlRightTerm = widget.team.right!.admin_term;
    _ctrlRightUser = widget.team.right!.admin_users;
  }

  void _gatherTeam() {
    widget.team.name = _ctrlName.text;
    widget.team.description = _ctrlDescription.text;
    widget.team.right!.admin_courses = _ctrlRightCourse;
    widget.team.right!.admin_rankings = _ctrlRightRanking;
    widget.team.right!.admin_event = _ctrlRightEvent;
    widget.team.right!.admin_inventory = _ctrlRightInventory;
    widget.team.right!.admin_teams = _ctrlRightTeam;
    widget.team.right!.admin_users = _ctrlRightUser;
  }

  void _submitTeam() async {
    _gatherTeam();

    bool success;
    if (widget.isDraft)
      success = await server.team_create(widget.session, widget.team);
    else
      success = await server.team_edit(widget.session, widget.team);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit team')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully edited team')));
    Navigator.pop(context);
  }

  void _deleteTeam() async {
    if (!await server.team_delete(widget.session, widget.team)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete team')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted team')));
    Navigator.pop(context);
  }

  Future<void> _duplicateTeam() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamAdminPage(
          session: widget.session,
          team: Team.fromTeam(widget.team),
          isDraft: true,
        ),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _getTeamMemberPool() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    setState(() {
      _memberPool = users;
    });
  }

  Future<void> _getTeamMemberList() async {
    List<User> users = await server.team_member_list(widget.session, widget.team.id);
    users.sort();

    setState(() {
      _memberList = users;
    });
  }

  void _addMember(User user) async {
    bool success = await server.team_member_add(widget.session, widget.team.id, user.id);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add member')));
      return;
    }

    _getTeamMemberList();
  }

  void _removeMember(User user) async {
    bool success = await server.team_member_remove(widget.session, widget.team.id, user.id);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove member')));
      return;
    }

    _getTeamMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Team Details"),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            Row(
              children: [
                Expanded(
                  child: AppTeamTile(
                    team: widget.team,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: _duplicateTeam,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteTeam,
                ),
              ],
            ),
          PanelSwiper(panels: [
            if (!widget.isDraft) Panel("Members", SelectionPanel<User>(
              available: _memberPool,
              chosen: _memberList,
              onAdd: _addMember,
              onRemove: _removeMember,
              filter: filterUsers,
              builder: (User user) => AppUserTile(user: user),
            )),
            Panel("Edit", _buildEditPanel()),
          ]),
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
            onChanged: (bool? enabled) => setState(() => _ctrlRightCourse = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Event Edit"),
          child: Checkbox(
            value: _ctrlRightEvent,
            onChanged: (bool? enabled) => setState(() => _ctrlRightEvent = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Inventory Edit"),
          child: Checkbox(
            value: _ctrlRightInventory,
            onChanged: (bool? enabled) => setState(() => _ctrlRightInventory = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Ranking Edit"),
          child: Checkbox(
            value: _ctrlRightRanking,
            onChanged: (bool? enabled) => setState(() => _ctrlRightRanking = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Team Edit"),
          child: Checkbox(
            value: _ctrlRightTeam,
            onChanged: (bool? enabled) => setState(() => _ctrlRightTeam = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("Term Edit"),
          child: Checkbox(
            value: _ctrlRightTerm,
            onChanged: (bool? enabled) => setState(() => _ctrlRightTerm = enabled!),
          ),
        ),
        AppInfoRow(
          info: Text("User Edit"),
          child: Checkbox(
            value: _ctrlRightUser,
            onChanged: (bool? enabled) => setState(() => _ctrlRightUser = enabled!),
          ),
        ),
        AppButton(
          text: "Save",
          onPressed: _submitTeam,
        ),
      ],
    );
  }
}
