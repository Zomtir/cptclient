import 'package:cptclient/api/admin/event/imports.dart' as api_admin;
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/gender.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/extensions.dart';
import 'package:flutter/material.dart';

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
                      child: Text(AppLocalizations.of(context)!.userGender),
                      onTap: () =>
                          setState(() => _stats.sort((a, b) => nullCompareTo<Gender>(a.user!.gender, b.user!.gender))),
                    ),
                  ),
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.userBirthDate),
                      onTap: () =>
                          setState(() => _stats.sort((a, b) => nullCompareTo(a.user!.birth_date, b.user!.birth_date))),
                    ),
                  ),
                  DataColumn(
                    label: InkWell(
                      child: Text(AppLocalizations.of(context)!.userAgeEOY),
                      onTap: () =>
                          setState(() => _stats.sort((a, b) => nullCompareTo(a.user!.birth_date, b.user!.birth_date, revert: true))),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(_stats.length, (index) {
                  String pm_solo_date = _stats[index].permission_solo_date == null
                      ? AppLocalizations.of(context)!.unknown
                      : "${_stats[index].permission_solo_date!.fmtDate(context)}";
                  String pm_team_date = _stats[index].permission_team_date == null
                      ? AppLocalizations.of(context)!.unknown
                      : "${_stats[index].permission_team_date!.fmtDate(context)}";
                  String rd_move_date = _stats[index].residency_move_date == null
                      ? AppLocalizations.of(context)!.unknown
                      : "${_stats[index].residency_move_date!.fmtDate(context)}";

                  String desc_solo_date = AppLocalizations.of(context)!.affiliationPermissionSoloDate;
                  String desc_team_date = AppLocalizations.of(context)!.affiliationPermissionTeamDate;
                  String desc_move_date = AppLocalizations.of(context)!.affiliationResidencyMoveDate;

                  return DataRow(
                    cells: <DataCell>[
                      DataCell(_stats[index].user!.buildEntry()),
                      DataCell(_stats[index].organisation == null
                          ? Text(AppLocalizations.of(context)!.undefined)
                          : _stats[index].organisation!.buildEntry()),
                      DataCell(
                        _stats[index].member_identifier == null
                            ? Text(AppLocalizations.of(context)!.unknown)
                            : Tooltip(
                                child: Text("${_stats[index].member_identifier}"),
                                message:
                                    "$desc_solo_date: $pm_solo_date\n$desc_team_date: $pm_team_date\n$desc_move_date: $rd_move_date",
                              ),
                      ),
                      DataCell(Text(_stats[index].user!.gender == null
                          ? AppLocalizations.of(context)!.unknown
                          : "${_stats[index].user!.gender!.localizedName(context)}")),
                      DataCell(Text(_stats[index].user!.birth_date == null
                          ? AppLocalizations.of(context)!.unknown
                          : "${_stats[index].user!.birth_date!.fmtDate(context)}")),
                      DataCell(Text(_stats[index].user!.birth_date == null
                          ? AppLocalizations.of(context)!.unknown
                          : "${widget.event.begin.year - _stats[index].user!.birth_date!.year}")),
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
