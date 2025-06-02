import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/EventDetailPage.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:flutter/material.dart';

class CourseStatisticClassPage extends StatefulWidget {
  final UserSession session;
  final Course course;

  CourseStatisticClassPage({super.key, required this.session, required this.course});

  @override
  CourseStatisticClassPageState createState() => CourseStatisticClassPageState();
}

class CourseStatisticClassPageState extends State<CourseStatisticClassPage> {
  CourseStatisticClassPageState();

  List<(Event, int, int, int)> stats = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<(Event, int, int, int)> stats = await api_admin.course_statistic_class(widget.session, widget.course.id);
    stats.sort((a, b) => a.$1.compareTo(b.$1));
    setState(() => this.stats = stats);
  }

  Future<void> _handleEvent(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          eventID: event.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseStatisticClasses),
      ),
      body: AppBody(
        maxWidth: 1000,
        children: <Widget>[
          AppCourseTile(
            course: widget.course,
          ),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.event)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventTitle)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventBegin)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventEnd)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventParticipant)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventLeader)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventSupporter)),
            ],
            rows: List<DataRow>.generate(stats.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(IconButton(icon: Icon(Icons.shortcut), onPressed: () => _handleEvent(stats[index].$1))),
                  DataCell(Text("${stats[index].$1.title}")),
                  DataCell(Text("${stats[index].$1.begin.fmtDateTime(context)}")),
                  DataCell(Text("${stats[index].$1.end.fmtDateTime(context)}")),
                  DataCell(Text("${stats[index].$4}")),
                  DataCell(Text("${stats[index].$2}")),
                  DataCell(Text("${stats[index].$3}")),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
