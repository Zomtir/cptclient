import 'package:cptclient/api/admin/event/imports.dart' as api_admin;
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventStatisticOrganisationPage extends StatefulWidget {
  final UserSession session;
  final Event event;
  final Organisation organisation;

  EventStatisticOrganisationPage({super.key, required this.session, required this.event, required this.organisation});

  @override
  EventStatisticOrganisationPageState createState() => EventStatisticOrganisationPageState();
}

class EventStatisticOrganisationPageState extends State<EventStatisticOrganisationPage> {
  List<Affiliation> _stats = [];

  EventStatisticOrganisationPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<Affiliation>? stats =
        await api_admin.event_statistic_organisation(widget.session, widget.event, widget.organisation);

    if (stats == null) {
      Navigator.of(context).pop();
      return;
    }

    stats.sort((a, b) => nullCompareTo(a.user, b.user));
    setState(() => _stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventStatisticOrganisation),
      ),
      body: AppBody(
        maxWidth: 1500,
        children: <Widget>[
          AppEventTile(
            event: widget.event,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1500,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.user),
                      onTap: () => setState(() => _stats.sort((a, b) => nullCompareTo(a.user, b.user))),
                    ),
                  ),
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.organisation),
                      onTap: () => setState(() => _stats.sort((a, b) => nullCompareTo(a.organisation, b.organisation))),
                    ),
                  ),
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.affiliationMemberIdentifier),
                      onTap: () => setState(
                          () => _stats.sort((a, b) => nullCompareTo(a.member_identifier, b.member_identifier))),
                    ),
                  ),
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.affiliationPermissionSoloDate),
                      onTap: () => setState(
                          () => _stats.sort((a, b) => nullCompareTo(a.permission_solo_date, b.permission_solo_date))),
                    ),
                  ),
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.affiliationPermissionTeamDate),
                      onTap: () => setState(
                          () => _stats.sort((a, b) => nullCompareTo(a.permission_team_date, b.permission_team_date))),
                    ),
                  ),
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.affiliationResidencyMoveDate),
                      onTap: () => setState(
                          () => _stats.sort((a, b) => nullCompareTo(a.residency_move_date, b.residency_move_date))),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(_stats.length, (index) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(_stats[index].user!.buildEntry()),
                      DataCell(_stats[index].organisation == null
                          ? Text(AppLocalizations.of(context)!.undefined)
                          : _stats[index].organisation!.buildEntry()),
                      DataCell(Text(_stats[index].member_identifier == null
                          ? AppLocalizations.of(context)!.unknown
                          : "${_stats[index].member_identifier}")),
                      DataCell(Text(_stats[index].permission_solo_date == null
                          ? AppLocalizations.of(context)!.unknown
                          : "${_stats[index].permission_solo_date!.fmtDate(context)}")),
                      DataCell(Text(_stats[index].permission_team_date == null
                          ? AppLocalizations.of(context)!.unknown
                          : "${_stats[index].permission_team_date!.fmtDate(context)}")),
                      DataCell(Text(_stats[index].residency_move_date == null
                          ? AppLocalizations.of(context)!.unknown
                          : "${_stats[index].residency_move_date!.fmtDate(context)}")),
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
