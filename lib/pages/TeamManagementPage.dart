import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/pages/TeamEditPage.dart';
import 'package:cptclient/pages/TeamMemberPage.dart';
import 'package:cptclient/static/server_team_admin.dart' as server;
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
    List<Team> teams = await server.team_list(widget.session);

    setState(() {
      _teams = teams;
    });
  }

  Future<void> _selectTeam(Team team) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamMemberPage(
          session: widget.session,
          team: team,
        ),
      ),
    );

    _update();
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
            text: AppLocalizations.of(context)!.actionNew,
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
