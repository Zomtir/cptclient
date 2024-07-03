import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/FilterToggle.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/static/server_club_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubStatisticMemberPage extends StatefulWidget {
  final UserSession session;
  final Club club;

  ClubStatisticMemberPage({super.key, required this.session, required this.club});

  @override
  ClubStatisticMemberPageState createState() => ClubStatisticMemberPageState();
}

class ClubStatisticMemberPageState extends State<ClubStatisticMemberPage> {
  final DateTimeController _ctrlDate = DateTimeController(dateTime: DateTime.now());

  List<(User, int)> stats = [];

  ClubStatisticMemberPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<(User, int)> stats = await api_admin.club_statistic_members(widget.session, widget.club, _ctrlDate.getDate());
    stats.sort((a, b) => a.$2.compareTo(b.$2));
    setState(() => this.stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubStatisticMember),
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
                info: AppLocalizations.of(context)!.termDate,
                child: DateTimeEdit(
                  controller: _ctrlDate,
                  showTime: false,
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
                  DataColumn(label: Text('Years')),
                ],
                rows: List<DataRow>.generate(stats.length, (index) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text("${stats[index].$1.id}")),
                      DataCell(Text("${stats[index].$1.firstname} ${stats[index].$1.lastname}")),
                      DataCell(Text((stats[index].$2/365).toStringAsPrecision(2))),
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
