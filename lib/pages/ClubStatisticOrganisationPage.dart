import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/FilterToggle.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubStatisticOrganisationPage extends StatefulWidget {
  final UserSession session;
  final Club club;
  final Organisation organisation;

  ClubStatisticOrganisationPage({super.key, required this.session, required this.club, required this.organisation});

  @override
  ClubStatisticOrganisationPageState createState() => ClubStatisticOrganisationPageState();
}

class ClubStatisticOrganisationPageState extends State<ClubStatisticOrganisationPage> {
  final DateTimeController _ctrlDate = DateTimeController(dateTime: DateTime.now());

  List<Affiliation> _stats = [];

  ClubStatisticOrganisationPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<Affiliation>? stats =
        await api_admin.club_statistic_organisation(widget.session, widget.club, widget.organisation, _ctrlDate.getDate());

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
        title: Text(AppLocalizations.of(context)!.pageClubStatisticOrganisation),
      ),
      body: AppBody(
        maxWidth: 1500,
        children: <Widget>[
          AppClubTile(
            club: widget.club,
          ),
          FilterToggle(
            hidden: false,
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
