import 'package:cptclient/api/admin/team/team.dart' as api_admin;
import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/pages/TeamEditPage.dart';
import 'package:cptclient/pages/TeamRightPage.dart';
import 'package:flutter/material.dart';

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
          tile: Team.buildListTile(context, team),
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
    int? newTeamID = await api_admin.team_create(session, Team.fromTeam(team));

    if (newTeamID == null) return;
    List<User> members = await api_admin.team_member_list(session, team.id);

    for (User member in members){
      api_admin.team_member_add(session, newTeamID, member.id);
    }
    Navigator.pop(context);

    Team? newTeam = await api_admin.team_info(session, newTeamID);
    if (newTeam == null) return;

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
          Team.buildListTile(
            context,
            team,
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
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageTeamMember),
                onTap: () => _handleMember(context),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageTeamRight),
                onTap: () => _handleRight(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
