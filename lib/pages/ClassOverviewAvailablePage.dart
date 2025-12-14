import 'package:cptclient/api/regular/event/event.dart' as api_regular;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/pages/EventDetailPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ClassOverviewAvailablePage extends StatefulWidget {
  final UserSession session;
  final Course course;

  ClassOverviewAvailablePage(
      {super.key, required this.session, required this.course});

  @override
  ClassOverviewAvailablePageState createState() =>
      ClassOverviewAvailablePageState();
}

class ClassOverviewAvailablePageState
    extends State<ClassOverviewAvailablePage> {
  List<Event> _events = [];

  ClassOverviewAvailablePageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _getCourseEvents();
  }

  Future<void> _getCourseEvents() async {
    var result = await api_regular.event_list(
      widget.session,
      courseTrue: true,
      courseID: widget.course.id,
    );
    if (result is! Success) return;
    List<Event> events = result.unwrap();
    events.sort();

    setState(() {
      _events = events;
    });
  }

  Future<void> _selectCourseEvent(Event event, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          eventID: event.id,
        ),
      ),
    );

    _getCourseEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventAvailable),
      ),
      body: AppBody(
        children: <Widget>[
          widget.course.buildCard(context),
          AppListView<Event>(
            items: _events,
            itemBuilder: (Event event) => event.buildTile(context,
              onTap: () => _selectCourseEvent(event, false),
              trailing: [
                IconButton(onPressed: null, icon: Icon(Icons.star_border)),
                IconButton(onPressed: null, icon: Icon(Icons.star)),
                IconButton(onPressed: null, icon: Icon(Icons.group_add)),
                IconButton(onPressed: null, icon: Icon(Icons.group_off)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
