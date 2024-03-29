import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/pages/TeamDetailManagementPage.dart';
import 'package:cptclient/pages/TeamEditPage.dart';
import 'package:cptclient/static/server_team_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamOverviewManagementPage extends StatefulWidget {
  final Session session;

  TeamOverviewManagementPage({super.key, required this.session});

  @override
  TeamOverviewManagementPageState createState() =>
      TeamOverviewManagementPageState();
}

class TeamOverviewManagementPageState
    extends State<TeamOverviewManagementPage> {
  List<Team> _teams = [];

  TeamOverviewManagementPageState();

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

  Future<void> _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamEditPage(
          session: widget.session,
          team: Team.fromVoid(),
          isDraft: true,
        ),
      ),
    );

    _update();
  }

  Future<void> _handleSelect(Team team) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDetailManagementPage(
          session: widget.session,
          team: team,
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
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
          AppListView(
            items: _teams,
            itemBuilder: (Team team) {
              return InkWell(
                onTap: () => _handleSelect(team),
                child: AppTeamTile(team: team),
              );
            },
          ),
        ],
      ),
    );
  }
}
