import 'package:cptclient/api/admin/team/team.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/widgets/AppBody.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/AppInfoRow.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class TeamCreatePage extends StatefulWidget {
  final UserSession session;
  final Team team;

  TeamCreatePage(
      {super.key,
      required this.session,
      required this.team,
      });

  @override
  TeamCreatePageState createState() => TeamCreatePageState();
}

class TeamCreatePageState extends State<TeamCreatePage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();

  TeamCreatePageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _applyTeam();
  }

  void _applyTeam() {
    _ctrlKey.text = widget.team.key;
    _ctrlName.text = widget.team.name;
    _ctrlDescription.text = widget.team.description;
  }

  void _gatherTeam() {
    widget.team.key = _ctrlKey.text;
    widget.team.name = _ctrlName.text;
    widget.team.description = _ctrlDescription.text;
  }

  void _submitTeam() async {
    if (_ctrlKey.text.isEmpty || _ctrlKey.text.length > 10) {
      messageText("${AppLocalizations.of(context)!.teamKey} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (_ctrlName.text.isEmpty || _ctrlName.text.length > 30) {
      messageText("${AppLocalizations.of(context)!.teamName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (_ctrlDescription.text.isEmpty || _ctrlDescription.text.length > 100) {
      messageText("${AppLocalizations.of(context)!.teamDescription} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    _gatherTeam();

    Result result = await api_admin.team_create(widget.session, widget.team);

    if (result is! Success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTeamEdit),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.teamKey,
            child: TextField(
              maxLines: 1,
              controller: _ctrlKey,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.teamName,
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.teamDescription,
            child: TextField(
              maxLines: 1,
              controller: _ctrlDescription,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _submitTeam,
          ),
        ],
      ),
    );
  }
}
