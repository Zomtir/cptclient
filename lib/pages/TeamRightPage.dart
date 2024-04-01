import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/static/server_team_admin.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamRightPage extends StatefulWidget {
  final Session session;
  final Team team;

  TeamRightPage({
    super.key,
    required this.session,
    required this.team,
  });

  @override
  TeamRightPageState createState() => TeamRightPageState();
}

class TeamRightPageState extends State<TeamRightPage> {
  List<Permission> permissions = [];

  TeamRightPageState();

  @override
  void initState() {
    super.initState();
    _applyRight();
  }

  void _applyRight() {
    permissions = widget.team.right!.toList();
  }

  void _gatherRight() {
    widget.team.right!.fromList(permissions);
  }

  void _handleSubmit() async {
    _gatherRight();

    bool success = await server.team_right_edit(widget.session, widget.team);

    if (!success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTeamRight),
      ),
      body: AppBody(
        children: [
          AppTeamTile(team: widget.team),
          Divider(),
          DataTable(
            columns: const [
              DataColumn(label: Text('Permission')),
              DataColumn(label: Text('Read')),
              DataColumn(label: Text('Write')),
            ],
            rows: List<DataRow>.generate(permissions.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text("${permissions[index].name}")),
                  DataCell(
                    Checkbox(
                      value: permissions[index].read,
                      onChanged: (bool? enabled) =>
                          setState(() => permissions[index] =  permissions[index].copyWith(read: enabled!)),
                    ),
                  ),
                  DataCell(
                    Checkbox(
                      value: permissions[index].write,
                      onChanged: (bool? enabled) =>
                          setState(() => permissions[index] =  permissions[index].copyWith(write: enabled!)),
                    ),
                  ),
                ],
              );
            }),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
