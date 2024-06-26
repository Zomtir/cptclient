import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/EventDetailManagementPage.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseStatisticOwner1Page extends StatefulWidget {
  final UserSession session;
  final Course course;
  final int ownerID;

  CourseStatisticOwner1Page({super.key, required this.session, required this.course, required this.ownerID});

  @override
  CourseStatisticOwner1PageState createState() => CourseStatisticOwner1PageState();
}

class CourseStatisticOwner1PageState extends State<CourseStatisticOwner1Page> {
  CourseStatisticOwner1PageState();

  List<(int, String, DateTime, DateTime)> stats = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<(int, String, DateTime, DateTime)> stats = await api_admin.course_statistic_owner1(widget.session, widget.course.id, widget.ownerID);
    stats.sort((a, b) => a.$3.compareTo(b.$3));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseStatisticOwners),
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
                  DataCell(InkWell(child: Text("${stats[index].$1}"), onTap: () => _handleEvent(stats[index].$1))),
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
