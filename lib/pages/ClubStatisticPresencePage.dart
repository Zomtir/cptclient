import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/MultiChoiceEdit.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/FilterToggle.dart';
import 'package:cptclient/pages/EventDetailPage.dart';
import 'package:cptclient/pages/PresenceAccountingPage.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/export.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class ClubStatisticPresencePage extends StatefulWidget {
  final UserSession session;
  final Club club;
  final int userID;
  final String title;

  ClubStatisticPresencePage({
    super.key,
    required this.session,
    required this.club,
    required this.userID,
    required this.title,
  });

  @override
  ClubStatisticPresencePageState createState() => ClubStatisticPresencePageState();
}

class ClubStatisticPresencePageState extends State<ClubStatisticPresencePage> {
  final DateTimeController _ctrlBegin =
      DateTimeController(dateTime: DateUtils.dateOnly(DateTime.now()).copyWith(month: 1, day: 1));
  final DateTimeController _ctrlEnd =
      DateTimeController(dateTime: DateUtils.dateOnly(DateTime.now()).copyWith(month: 12, day: 31));
  late User _ctrlUser;
  String _ctrlRole = 'leader';

  List<Event> _eventList = [];

  ClubStatisticPresencePageState();

  @override
  void initState() {
    super.initState();
    _ctrlUser = widget.session.user!;
    _update();
  }

  void _update() async {
    List<Event>? eventList = await api_admin.club_statistic_presence(
      widget.session,
      widget.club.id,
      _ctrlUser.id,
      _ctrlBegin.getDate().copyWith(hour: 0),
      _ctrlEnd.getDate().copyWith(hour: 24),
      _ctrlRole,
    );
    if (eventList == null) return;
    eventList.sort();

    setState(() {
      _eventList = eventList;
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

  Future<void> _handlePresenceAccounting() async {
    User? userDetailed = await api_admin.user_detailed(widget.session, _ctrlUser.id);
    if (userDetailed == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PresenceAccountingPage(
          session: widget.session,
          club: widget.club,
          user: userDetailed,
          role: _ctrlRole,
          dateBegin: _ctrlBegin.getDateTime()!,
          dateEnd: _ctrlEnd.getDateTime()!,
          events: _eventList,
        ),
      ),
    );
  }

  _handlePresenceTable() {
    String fileName = "CPT_club_${widget.club.id}_user_${widget.userID}_presence_$_ctrlRole";
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
        actions: [
          IconButton(
            icon: const Icon(Icons.monetization_on_outlined),
            onPressed: _handlePresenceAccounting,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _handlePresenceTable,
          ),
        ],
      ),
      body: AppBody(
        maxWidth: 1000,
        children: <Widget>[
          FilterToggle(
            hidden: false,
            onApply: _update,
            children: [
              AppInfoRow(
                info: AppLocalizations.of(context)!.user,
                child: ListTile(
                  title: _ctrlUser.buildEntry(context),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      var users = await api_admin.user_list(widget.session);
                      users.sort();
                      useAppDialog<User?>(
                        context: context,
                        widget: MultiChoiceEdit<User>(
                          items: users,
                          value: _ctrlUser,
                          builder: (user) => user.buildEntry(context),
                          nullable: false,
                        ),
                        onChanged: (User? user) => setState(() => _ctrlUser = user!),
                      );
                    },
                  ),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventBegin,
                child: DateTimeField(controller: _ctrlBegin, showTime: false, nullable: false),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventEnd,
                child: DateTimeField(controller: _ctrlEnd, showTime: false, nullable: false),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventRole,
                child: ListTile(
                  title: Text(_ctrlRole),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String?>(
                      context: context,
                      widget: MultiChoiceEdit<String>(
                        items: ["leader", "supporter", "participant", "spectator"],
                        value: "leader",
                        builder: (role) => Text(role),
                        nullable: false,
                      ),
                      onChanged: (String? role) {
                        setState(() => _ctrlRole = role ?? 'leader');
                      },
                    ),
                  ),
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
