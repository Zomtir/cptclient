import 'package:cptclient/api/admin/team/team.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/TeamDetailPage.dart';
import 'package:cptclient/pages/TeamEditPage.dart';
import 'package:cptclient/utils/result.dart';
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
    Result<List<Team>> result = await api_admin.team_list(widget.session);
    if (result is! Success) return;
    searchPanelKey.currentState?.populate(result.unwrap());
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
    var result = await api_admin.team_info(widget.session, team.id);
    if (result is! Success) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDetailPage(
          session: widget.session,
          team: result.unwrap(),
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          SearchablePanel(
            key: searchPanelKey,
            onTap: _handleSelect,
          ),
        ],
      ),
    );
  }
}
