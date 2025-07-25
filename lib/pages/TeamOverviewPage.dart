import 'package:cptclient/api/admin/team/team.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/TeamDetailManagementPage.dart';
import 'package:cptclient/pages/TeamEditPage.dart';
import 'package:flutter/material.dart';

class TeamOverviewPage extends StatefulWidget {
  final UserSession session;

  TeamOverviewPage({super.key, required this.session});

  @override
  TeamOverviewPageState createState() => TeamOverviewPageState();
}

class TeamOverviewPageState extends State<TeamOverviewPage> {
  GlobalKey<SearchablePanelState<Team>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Team>? teams = await api_admin.team_list(widget.session);
    if (teams == null) return;
    teams.sort();
    searchPanelKey.currentState?.setItems(teams);
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
    Team? teamInfo = await api_admin.team_info(widget.session, team.id);
    if (teamInfo == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDetailManagementPage(
          session: widget.session,
          team: teamInfo,
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
          SearchablePanel(
            key: searchPanelKey,
            builder: (Team team, Function(Team)? onSelect) => InkWell(
              onTap: () => onSelect?.call(team),
              child: team.buildTile(context),
            ),
            onSelect: _handleSelect,
          )
        ],
      ),
    );
  }
}
