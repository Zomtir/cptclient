import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/CourseStatisticPresence1Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseStatisticPresencePage extends StatefulWidget {
  final UserSession session;
  final Course course;
  final String title;
  final Future<List<(int, String, String, int)>> Function() presence;
  final Future<List<(int, String, DateTime, DateTime)>> Function(int) presence1;

  CourseStatisticPresencePage(
      {super.key,
      required this.session,
      required this.course,
      required this.title,
      required this.presence,
      required this.presence1});

  @override
  CourseStatisticPresencePageState createState() => CourseStatisticPresencePageState();
}

class CourseStatisticPresencePageState extends State<CourseStatisticPresencePage> {
  CourseStatisticPresencePageState();

  List<(int, String, String, int)> stats = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<(int, String, String, int)> stats = await widget.presence();
    stats.sort((a, b) => a.$4.compareTo(b.$4));
    setState(() => this.stats = stats);
  }

  Future<void> _handleUser(int userID) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseStatisticPresence1Page(
          session: widget.session,
          course: widget.course,
          userID: userID,
          title: widget.title,
          presence1: widget.presence1,
        ),
      ),
    );
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
          ),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.user)),
              DataColumn(label: Text(AppLocalizations.of(context)!.userFirstname)),
              DataColumn(label: Text(AppLocalizations.of(context)!.userLastname)),
              DataColumn(label: Text(AppLocalizations.of(context)!.eventPresence)),
            ],
            rows: List<DataRow>.generate(stats.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(InkWell(child: Text("${stats[index].$1}"), onTap: () => _handleUser(stats[index].$1))),
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
