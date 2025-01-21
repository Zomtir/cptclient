import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/EventDetailManagementPage.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/export.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class CourseStatisticPresence1Page extends StatefulWidget {
  final UserSession session;
  final Course course;
  final int userID;
  final String title;
  final Future<List<Event>> Function(int) presence1;

  CourseStatisticPresence1Page(
      {super.key,
      required this.session,
      required this.course,
      required this.userID,
      required this.title,
      required this.presence1});

  @override
  CourseStatisticPresence1PageState createState() => CourseStatisticPresence1PageState();
}

class CourseStatisticPresence1PageState extends State<CourseStatisticPresence1Page> {
  CourseStatisticPresence1PageState();

  List<Event> stats = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<Event> stats = await widget.presence1(widget.userID);
    stats.sort((a, b) => a.compareTo(b));
    setState(() => this.stats = stats);
  }

  Future<void> _handleEvent(int eventID) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailManagementPage(
          session: widget.session,
          eventID: eventID,
        ),
      ),
    );
  }

  _handleCSV() {
    String fileName = "CPT_course_${widget.course.id}_user_${widget.userID}_presence";
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
    table.addAll(stats.map((row) => [
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
          AppCourseTile(
            course: widget.course,
            trailing: [
              IconButton(
                icon: const Icon(Icons.import_export),
                onPressed: _handleCSV,
              ),
            ],
          ),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.event)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventTitle)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventLocation)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventBegin)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventEnd)),
            ],
            rows: List<DataRow>.generate(stats.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(IconButton(icon: Icon(Icons.shortcut), onPressed: () => _handleEvent(stats[index].id))),
                  DataCell(Text("${stats[index].title}")),
                  DataCell(Text("${stats[index].location?.name ?? AppLocalizations.of(context)!.unknown}")),
                  DataCell(Text("${stats[index].begin.fmtDateTime(context)}")),
                  DataCell(Text("${stats[index].end.fmtDateTime(context)}")),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
