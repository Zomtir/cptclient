import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/static/server_course_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseStatisticParticipantPage extends StatefulWidget {
  final Session session;
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
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('First Name')),
              DataColumn(label: Text('Last Name')),
              DataColumn(label: Text('Participation')),
            ],
            rows: List<DataRow>.generate(stats.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text("${stats[index].$1}")),
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
