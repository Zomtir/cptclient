import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/pages/TeamEditPage.dart';
import 'package:cptclient/static/server_team_admin.dart' as api_admin;
import 'package:cptclient/static/server_user_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamManagementPage extends StatefulWidget {
  final Session session;

  TeamManagementPage({super.key, required this.session});

  @override
  TeamManagementPageState createState() => TeamManagementPageState();
}

class TeamManagementPageState extends State<TeamManagementPage> {
  List<Team> _teams = [];

  TeamManagementPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Team> teams = await api_admin.team_list(widget.session);
    teams.sort();

    setState(() {
      _teams = teams;
    });
  }

  Future<void> _selectTeam(Team team) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageTeamEdit,
          tile: AppTeamTile(team: team),
          onCallAvailable: (session) => api_admin.user_list(session),
          onCallSelected: (session) => api_admin.team_member_list(widget.session, team.id),
          onCallAdd: (session, user) => api_admin.team_member_add(widget.session, team.id, user.id),
          onCallRemove: (session, user) => api_admin.team_member_remove(widget.session, team.id, user.id),
          filter: filterUsers,
          builder: (User user) => AppUserTile(user: user),
        ),
      ),
    );
  }

  Future<void> _editTeam(Team team, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamEditPage(
          session: widget.session,
          team: team,
          isDraft: isDraft,
        ),
      ),
    );

    _update();
  }

  Future<void> _duplicateTeam(Team oldteam) async {
    Team newteam = Team.fromTeam(oldteam);
    int? teamId = await api_admin.team_create(widget.session, newteam);

    if (teamId == null) return;
    List<User> members = await api_admin.team_member_list(widget.session, oldteam.id);

    for (User member in members){
      api_admin.team_member_add(widget.session, teamId, member.id);
    }

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTeamManagement),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: () => _editTeam(Team.fromVoid(), true),
          ),
          AppListView(
            items: _teams,
            itemBuilder: (Team team) {
              return InkWell(
                onTap: () => _selectTeam(team),
                child: AppTeamTile(
                  team: team,
                  trailing: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _duplicateTeam(team),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editTeam(team, false),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
