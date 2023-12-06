import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/material/panels/SelectionPanel.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';

import '../static/serverUserMember.dart' as server;
import '../static/serverTeamAdmin.dart' as server;
import '../json/session.dart';
import '../json/team.dart';
import '../json/user.dart';

class TeamMemberPage extends StatefulWidget {
  final Session session;
  final Team team;

  TeamMemberPage({Key? key, required this.session, required this.team}) : super(key: key);

  @override
  TeamMemberPageState createState() => TeamMemberPageState();
}

class TeamMemberPageState extends State<TeamMemberPage> {
  List<User> _memberPool = [];
  List<User> _memberList = [];

  TeamMemberPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _getTeamMemberPool();
    _getTeamMemberList();
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
        title: Text(AppLocalizations.of(context)!.pageTeamEdit),
      ),
      body: AppBody(
        children: [
          AppTeamTile(
            team: widget.team,
          ),
      //SelectionPanel<User>(
      //    available: _memberPool,
      //    chosen: _memberList,
      //    onAdd: _addMember,
      //    onRemove: _removeMember,
      //    filter: filterUsers,
      //    builder: (User user) => AppUserTile(user: user),
          //  ),
        ],
      ),
    );
  }
}
