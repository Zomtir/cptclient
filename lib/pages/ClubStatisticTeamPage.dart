import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/FilterToggle.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/static/server_club_admin.dart' as api_admin;
import 'package:cptclient/static/server_team_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubStatisticTeamPage extends StatefulWidget {
  final Session session;
  final Club club;

  ClubStatisticTeamPage({super.key, required this.session, required this.club});

  @override
  ClubStatisticTeamPageState createState() => ClubStatisticTeamPageState();
}

class ClubStatisticTeamPageState extends State<ClubStatisticTeamPage> {
  final DateTimeController _ctrlDate = DateTimeController(dateTime: DateTime.now());
  final FieldController<Team> _ctrlTeam = FieldController<Team>();

  List<User> stats = [];

  ClubStatisticTeamPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    _ctrlTeam.callItems = () => api_regular.team_list(widget.session);

    if (_ctrlTeam.value == null) return;

    List<User> stats = await api_admin.club_statistic_team(widget.session, widget.club, _ctrlDate.getDate(), _ctrlTeam.value!);
    stats.sort();
    setState(() => this.stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubStatisticTeam),
      ),
      body: AppBody(
        children: <Widget>[
          AppClubTile(
            club: widget.club,
          ),
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.termDate),
                child: DateTimeEdit(
                  controller: _ctrlDate,
                  showTime: false,
                ),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.termClub),
                child: AppField<Team>(
                  controller: _ctrlTeam,
                  onChanged: (Team? team) =>
                      setState(() => _ctrlTeam.value = team),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 600,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Member')),
                ],
                rows: List<DataRow>.generate(stats.length, (index) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text("${stats[index].id}")),
                      DataCell(Text("${stats[index].firstname} ${stats[index].lastname}")),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
