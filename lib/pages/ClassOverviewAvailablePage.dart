import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventInfoPage.dart';
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassOverviewAvailablePage extends StatefulWidget {
  final Session session;
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
    List<Event> events = await api_regular.event_list(
      widget.session,
      courseTrue: true,
      courseID: widget.course.id,
    );
    events.sort();

    setState(() {
      _events = events;
    });
  }

  Future<void> _selectCourseEvent(Event event, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventInfoPage(
          session: widget.session,
          event: event,
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
          AppCourseTile(
            course: widget.course,
          ),
          AppListView<Event>(
            items: _events,
            itemBuilder: (Event event) {
              return InkWell(
                onTap: () => _selectCourseEvent(event, false),
                child: AppEventTile(
                  event: event,
                  trailing: [
                    IconButton(onPressed: null, icon: Icon(Icons.star_border)),
                    IconButton(onPressed: null, icon: Icon(Icons.star)),
                    IconButton(onPressed: null, icon: Icon(Icons.group_add)),
                    IconButton(onPressed: null, icon: Icon(Icons.group_off)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
