import 'package:cptclient/api/admin/event/imports.dart' as api_admin;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:cptclient/static/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventStatisticOrganisationPage extends StatefulWidget {
  final UserSession session;
  final Event event;

  EventStatisticOrganisationPage({super.key, required this.session, required this.event});

  @override
  EventStatisticOrganisationPageState createState() => EventStatisticOrganisationPageState();
}

class EventStatisticOrganisationPageState extends State<EventStatisticOrganisationPage> {
  List<User> _stats = [];

  EventStatisticOrganisationPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<User> stats = await api_admin.event_statistic_organisation(widget.session, widget.event);
    stats.sort();
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
                      child: Text(AppLocalizations.of(context)!.userFederationPermissionSoloDate),
                      onTap: () => setState(() => _stats.sort((a, b) => nullCompareTo(a.federationpermissionsolo, b.federationpermissionsolo))),
                    ),
                  ),
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.userFederationPermissionTeamDate),
                      onTap: () => setState(() => _stats.sort((a, b) => nullCompareTo(a.federationpermissionteam, b.federationpermissionteam))),
                    ),
                  ),
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.userFederationResidencyDate),
                      onTap: () => setState(() => _stats.sort((a, b) => nullCompareTo(a.federationresidency, b.federationresidency))),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(_stats.length, (index) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text("${_stats[index].toFieldString()}")),
                      DataCell(Text("${_stats[index].federationnumber}")),
                      DataCell(Text(_stats[index].federationpermissionsolo == null ? AppLocalizations.of(context)!.unknown : "${_stats[index].federationpermissionsolo!.fmtDate(context)}")),
                      DataCell(Text(_stats[index].federationpermissionteam == null ? AppLocalizations.of(context)!.unknown : "${_stats[index].federationpermissionteam!.fmtDate(context)}")),
                      DataCell(Text(_stats[index].federationresidency == null ? AppLocalizations.of(context)!.unknown : "${_stats[index].federationresidency!.fmtDate(context)}")),
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
