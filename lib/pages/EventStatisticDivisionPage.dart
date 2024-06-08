import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:cptclient/static/server_event_admin.dart' as api_admin;
import 'package:cptclient/static/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventStatisticDivisionPage extends StatefulWidget {
  final Session session;
  final Event event;

  EventStatisticDivisionPage({super.key, required this.session, required this.event});

  @override
  EventStatisticDivisionPageState createState() => EventStatisticDivisionPageState();
}

class EventStatisticDivisionPageState extends State<EventStatisticDivisionPage> {
  EventStatisticDivisionPageState();

  List<User> _stats = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<User> stats = await api_admin.event_statistic_division(widget.session, widget.event);
    stats.sort();
    setState(() => _stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventStatisticDivision),
      ),
      body: AppBody(
        maxWidth: 1000,
        children: <Widget>[
          AppEventTile(
            event: widget.event,
          ),
          DataTable(
            columns: [
              DataColumn(
                label: InkWell(
                  child: Text(AppLocalizations.of(context)!.user),
                  onTap: () => setState(() => _stats.sort()),
                ),
              ),
              DataColumn(
                label: InkWell(
                  child: Text(AppLocalizations.of(context)!.userFederationNumber),
                  onTap: () => setState(() => _stats.sort((a, b) => nullCompareTo(a.federationnumber, b.federationnumber))),
                ),
              ),
              DataColumn(
                label: InkWell(
                  child: Text(AppLocalizations.of(context)!.userGender),
                  onTap: () => setState(() => _stats.sort((a, b) => nullCompareTo(a.gender, b.gender))),
                ),
              ),
              DataColumn(
                label: InkWell(
                  child: Text(AppLocalizations.of(context)!.userBirthday),
                  onTap: () => setState(() => _stats.sort((a, b) => nullCompareTo(a.birthday, b.birthday))),
                ),
              ),
              DataColumn(
                label: InkWell(
                  child: Text(AppLocalizations.of(context)!.userAgeEOY),
                  onTap: () => setState(() => _stats.sort((a, b) => -nullCompareTo(a.birthday, b.birthday))),
                ),
              ),
            ],
            rows: List<DataRow>.generate(_stats.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text("${_stats[index].toFieldString()}")),
                  DataCell(Text("${_stats[index].federationnumber}")),
                  DataCell(Text("${_stats[index].gender}")),
                  DataCell(Text(_stats[index].birthday == null ? AppLocalizations.of(context)!.unknown : "${_stats[index].birthday!.fmtDate(context)}")),
                  DataCell(Text(_stats[index].birthday == null ? AppLocalizations.of(context)!.unknown : "${widget.event.begin.year-_stats[index].birthday!.year}")),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
