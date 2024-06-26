import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/CourseStatisticParticipant1Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseStatisticParticipantPage extends StatefulWidget {
  final UserSession session;
  final Course course;

  CourseStatisticParticipantPage({super.key, required this.session, required this.course});

  @override
  CourseStatisticParticipantPageState createState() => CourseStatisticParticipantPageState();
}

class CourseStatisticParticipantPageState extends State<CourseStatisticParticipantPage> {
  CourseStatisticParticipantPageState();

  List<(int, String, String, int)> stats = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<(int, String, String, int)> stats = await api_admin.course_statistic_participant(widget.session, widget.course.id);
    stats.sort((a, b) => a.$4.compareTo(b.$4));
    setState(() => this.stats = stats);
  }

  Future<void> _handleParticipant(int participantID) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseStatisticParticipant1Page(
          session: widget.session,
          course: widget.course,
          participantID: participantID,
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
              DataColumn(label: Text('First Name')),
              DataColumn(label: Text('Last Name')),
              DataColumn(label: Text('Participation')),
            ],
            rows: List<DataRow>.generate(stats.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(InkWell(child: Text("${stats[index].$1}"), onTap: () => _handleParticipant(stats[index].$1))),
                  DataCell(Text("${stats[index].$2}")),
                  DataCell(Text("${stats[index].$3}")),
                  DataCell(Text("${stats[index].$4}")),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
