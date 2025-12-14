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
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class TeamDetailPage extends StatelessWidget {
  final UserSession session;
  final Team team;

  TeamDetailPage({super.key, required this.session, required this.team});

  Future<void> _handleMember(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageTeamMember,
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
    Result<int> resultId = (await api_admin.team_create(session, Team.fromTeam(team)));

    if (resultId is! Success) return;

    Result<List<User>> result_members = await api_admin.team_member_list(session, team.id);
    if (result_members is! Success) return;

    for (User member in result_members.unwrap()){
      api_admin.team_member_add(session, resultId.unwrap(), member.id);
    }
    Navigator.pop(context);

    Result<Team> result_team = await api_admin.team_info(session, resultId.unwrap());
    if (result_team is! Success) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamEditPage(
          session: session,
          team: result_team.unwrap(),
          isDraft: false,
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context) async {
    var result = await api_admin.team_delete(session, team);
    if (result is! Success) return;
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
          team.buildTile(
            context,
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
