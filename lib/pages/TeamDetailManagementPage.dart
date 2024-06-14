import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/pages/TeamEditPage.dart';
import 'package:cptclient/pages/TeamRightPage.dart';
import 'package:cptclient/static/server_team_admin.dart' as api_admin;
import 'package:cptclient/static/server_user_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamDetailManagementPage extends StatelessWidget {
  final UserSession session;
  final Team team;

  TeamDetailManagementPage({super.key, required this.session, required this.team});

  Future<void> _handleMember(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageTeamMember,
          tile: AppTeamTile(team: team),
          onCallAvailable: () => api_admin.user_list(session),
          onCallSelected: () => api_admin.team_member_list(session, team.id),
          onCallAdd: (user) => api_admin.team_member_add(session, team.id, user.id),
          onCallRemove: (user) => api_admin.team_member_remove(session, team.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleEdit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamEditPage(
          session: session,
          team: team,
          isDraft: false,
        ),
      ),
    );
  }

  Future<void> _handleRight(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamRightPage(
          session: session,
          team: team,
        ),
      ),
    );
  }

  Future<void> _handleDuplicate(BuildContext context) async {
    Team newTeam = Team.fromTeam(team);
    int? newTeamID = await api_admin.team_create(session, newTeam);

    if (newTeamID == null) return;
    List<User> members = await api_admin.team_member_list(session, team.id);

    for (User member in members){
      api_admin.team_member_add(session, newTeamID, member.id);
    }
    Navigator.pop(context);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamEditPage(
          session: session,
          team: newTeam,
          isDraft: false,
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context) async {
    if (!await api_admin.team_delete(session, team)) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTeamManagement),
      ),
      body: AppBody(
        children: <Widget>[
          AppTeamTile(
            team: team,
            trailing: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _handleEdit(context),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _handleDuplicate(context),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _handleDelete(context),
              ),
            ],
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageTeamMember,
            onPressed: () => _handleMember(context),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageTeamRight,
            onPressed: () => _handleRight(context),
          ),
        ],
      ),
    );
  }
}
