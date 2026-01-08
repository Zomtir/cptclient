import 'package:cptclient/api/admin/team/team.dart' as api_admin;
import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/TextEditDialog.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/widgets/AppBody.dart';
import 'package:cptclient/material/widgets/AppInfoRow.dart';
import 'package:cptclient/material/widgets/MenuSection.dart';
import 'package:cptclient/pages/TeamCreatePage.dart';
import 'package:cptclient/pages/TeamRightPage.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class TeamDetailPage extends StatefulWidget {
  final UserSession session;
  final Team team;

  TeamDetailPage({super.key, required this.session, required this.team});

  @override
  TeamDetailPageState createState() => TeamDetailPageState();
}

class TeamDetailPageState extends State<TeamDetailPage> {
  late Team team = widget.team;

  TeamDetailPageState();

  Future<void> submit() async {
    Result result = await api_admin.team_edit(widget.session, team);
    if (result is! Success) return;
    update();
  }

  Future<void> update() async {
    Result result = await api_admin.team_info(widget.session, team.id);
    if (result is! Success) return;
    setState(() => team = result.unwrap());
  }

  Future<void> _handleMember() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageTeamMember,
          onCallAvailable: () => api_admin.user_list(widget.session),
          onCallSelected: () => api_admin.team_member_list(widget.session, team.id),
          onCallAdd: (user) => api_admin.team_member_add(widget.session, team.id, user.id),
          onCallRemove: (user) => api_admin.team_member_remove(widget.session, team.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleRight() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamRightPage(
          session: widget.session,
          team: team,
        ),
      ),
    );
  }

  Future<void> _handleDuplicate() async {
    Result<int> resultId = (await api_admin.team_create(widget.session, Team.fromTeam(team)));

    if (resultId is! Success) return;

    Result<List<User>> result_members = await api_admin.team_member_list(widget.session, team.id);
    if (result_members is! Success) return;

    for (User member in result_members.unwrap()) {
      api_admin.team_member_add(widget.session, resultId.unwrap(), member.id);
    }
    Navigator.pop(context);

    Result<Team> result_team = await api_admin.team_info(widget.session, resultId.unwrap());
    if (result_team is! Success) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamCreatePage(
          session: widget.session,
          team: result_team.unwrap(),
        ),
      ),
    );
  }

  void _handleDelete() async {
    var result = await api_admin.team_delete(widget.session, team);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTeamManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _handleDuplicate(),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _handleDelete(),
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          AppInfoRow(
            info: AppLocalizations.of(context)!.teamKey,
            child: Text(team.key),
            actions: [
              IconButton(
                onPressed: () => clipText(team.key),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: team.key,
                    minLength: 1,
                    maxLength: 20,
                    onConfirm: (String t) {
                      setState(() => team.key = t);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.teamName}",
            child: Text(team.name),
            actions: [
              IconButton(
                onPressed: () => clipText(team.name),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: team.name,
                    minLength: 1,
                    maxLength: 30,
                    onConfirm: (String t) {
                      setState(() => team.name = t);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.teamDescription}",
            child: Text(team.description),
            actions: [
              IconButton(
                onPressed: () => clipText(team.description),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: team.description,
                    minLength: 1,
                    maxLength: 30,
                    onConfirm: (String t) {
                      setState(() => team.description = t);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageTeamMember),
                onTap: () => _handleMember(),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageTeamRight),
                onTap: () => _handleRight(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
