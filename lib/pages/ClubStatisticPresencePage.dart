import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/material/widgets/FilterToggle.dart';
import 'package:cptclient/pages/EventDetailPage.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/export.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/trainer_accounting.dart';
import 'package:flutter/material.dart';

class ClubStatisticPresencePage extends StatefulWidget {
  final UserSession session;
  final Club club;
  final int userID;
  final String title;
  final Future<List<Event>?> Function(int, DateTime, DateTime, String) presence;

  ClubStatisticPresencePage({
    super.key,
    required this.session,
    required this.club,
    required this.userID,
    required this.title,
    required this.presence,
  });

  @override
  ClubStatisticPresencePageState createState() => ClubStatisticPresencePageState();
}

class ClubStatisticPresencePageState extends State<ClubStatisticPresencePage> {
  final DateTimeController _ctrlBegin =
      DateTimeController(dateTime: DateUtils.dateOnly(DateTime.now()).copyWith(month: 1, day: 1));
  final DateTimeController _ctrlEnd =
      DateTimeController(dateTime: DateUtils.dateOnly(DateTime.now()).copyWith(month: 12, day: 31));
  final TextEditingController _ctrlRole = TextEditingController(text: 'leader');
  final TextEditingController _ctrlDiscipline = TextEditingController();

  List<Event> _eventList = [];
  User? _userInfo;

  ClubStatisticPresencePageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<Event>? eventList = await widget.presence(
        widget.userID, _ctrlBegin.getDate().copyWith(hour: 0), _ctrlEnd.getDate().copyWith(hour: 24), _ctrlRole.text);
    if (eventList == null) return;
    eventList.sort();

    User? userInfo = await api_admin.user_detailed(widget.session, widget.session.user!.id);
    if (userInfo == null) return;

    setState(() {
      _eventList = eventList;
      _userInfo = userInfo;
    });
  }

  Future<void> _handleEvent(int eventID) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          eventID: eventID,
        ),
      ),
    );
  }

  Future<void> _handleTrainerAccounting() async {
    trainer_accounting_pdf(
        context, widget.club, _userInfo!, _ctrlDiscipline.text, _ctrlBegin.getDate(), _ctrlEnd.getDate(), _eventList);
  }

  _handlePresenceTable() {
    String fileName = "CPT_club_${widget.club.id}_user_${widget.userID}_presence_${_ctrlRole.text}";
    List<String> headers = [
      AppLocalizations.of(context)!.eventTitle,
      AppLocalizations.of(context)!.eventLocation,
      AppLocalizations.of(context)!.eventBegin,
      AppLocalizations.of(context)!.dateTime,
      AppLocalizations.of(context)!.eventEnd,
      AppLocalizations.of(context)!.dateTime,
      AppLocalizations.of(context)!.dateMinute,
    ];
    List<List<String?>> table = [headers];
    table.addAll(_eventList.map((row) => [
          row.title.toString(),
          row.location?.name ?? AppLocalizations.of(context)!.unknown,
          formatIsoDate(row.begin),
          formatIsoTime(row.begin),
          formatIsoDate(row.end),
          formatIsoTime(row.end),
          row.end.difference(row.begin).inMinutes.toString(),
        ]));
    exportCSV(fileName, table);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AppBody(
        maxWidth: 1000,
        children: <Widget>[
          AppClubTile(club: widget.club),
          User.buildListTile(
            context,
            widget.session.user!,
            trailing: [
              IconButton(
                icon: const Icon(Icons.monetization_on_outlined),
                onPressed: _handleTrainerAccounting,
              ),
              IconButton(
                icon: const Icon(Icons.import_export),
                onPressed: _handlePresenceTable,
              ),
            ],
          ),
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventBegin,
                child: DateTimeField(controller: _ctrlBegin, showTime: false),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventEnd,
                child: DateTimeField(controller: _ctrlEnd, showTime: false),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventRole,
                child: TextField(
                  maxLines: 1,
                  controller: _ctrlRole,
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.userDiscipline,
                child: TextField(
                  maxLines: 1,
                  controller: _ctrlDiscipline,
                ),
              ),
            ],
          ),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.event)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventLocation)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventTitle)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventBegin)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventEnd)),
            ],
            rows: List<DataRow>.generate(_eventList.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(IconButton(icon: Icon(Icons.shortcut), onPressed: () => _handleEvent(_eventList[index].id))),
                  DataCell(Text("${_eventList[index].location?.name ?? AppLocalizations.of(context)!.unknown}")),
                  DataCell(Text("${_eventList[index].title}")),
                  DataCell(Text("${_eventList[index].begin.fmtDateTime(context)}")),
                  DataCell(Text("${_eventList[index].end.fmtDateTime(context)}")),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
