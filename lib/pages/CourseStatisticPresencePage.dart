import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/CourseStatisticPresence1Page.dart';
import 'package:flutter/material.dart';

class CourseStatisticPresencePage extends StatefulWidget {
  final UserSession session;
  final Course course;
  final String title;
  final Future<List<(User, int)>> Function() presence;
  final Future<List<Event>> Function(int) presence1;

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

  List<(User, int)> stats = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<(User, int)> stats = await widget.presence();
    stats.sort((a, b) => a.$2.compareTo(b.$2));
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
              DataColumn(label: Text(AppLocalizations.of(context)!.eventPresence)),
            ],
            rows: List<DataRow>.generate(stats.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.list_alt_outlined),
                        onPressed: () => _handleUser(stats[index].$1.id),
                      ),
                      stats[index].$1.buildEntry(),
                    ],
                  )),
                  DataCell(Text("${stats[index].$2}")),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
