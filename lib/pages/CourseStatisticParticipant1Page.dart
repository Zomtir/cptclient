import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/EventDetailManagementPage.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:cptclient/static/server_course_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseStatisticParticipant1Page extends StatefulWidget {
  final Session session;
  final Course course;
  final int participantID;

  CourseStatisticParticipant1Page({super.key, required this.session, required this.course, required this.participantID});

  @override
  CourseStatisticParticipant1PageState createState() => CourseStatisticParticipant1PageState();
}

class CourseStatisticParticipant1PageState extends State<CourseStatisticParticipant1Page> {
  CourseStatisticParticipant1PageState();

  List<(int, String, DateTime, DateTime)> stats = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<(int, String, DateTime, DateTime)> stats = await api_admin.course_statistic_participant1(widget.session, widget.course.id, widget.participantID);
    stats.sort((a, b) => a.$3.compareTo(b.$3));
    setState(() => this.stats = stats);
  }

  Future<void> _handleClass(int eventID) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseStatisticParticipants),
      ),
      body: AppBody(
        maxWidth: 1000,
        children: <Widget>[
          AppCourseTile(
            course: widget.course,
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Begin')),
              DataColumn(label: Text('End')),
            ],
            rows: List<DataRow>.generate(stats.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(InkWell(child: Text("${stats[index].$1}"), onTap: () => _handleClass(stats[index].$1))),
                  DataCell(Text("${stats[index].$2}")),
                  DataCell(Text("${stats[index].$3.fmtDateTime(context)}")),
                  DataCell(Text("${stats[index].$4.fmtDateTime(context)}")),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
