import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventCreateBatchPage.dart';
import 'package:cptclient/pages/EventDetailManagementPage.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/static/server_event_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassOverviewManagementPage extends StatefulWidget {
  final Session session;
  final Course course;
  final bool isDraft;

  ClassOverviewManagementPage({super.key, required this.session, required this.course, required this.isDraft});

  @override
  ClassOverviewManagementPageState createState() => ClassOverviewManagementPageState();
}

class ClassOverviewManagementPageState extends State<ClassOverviewManagementPage> {
  List<Event> _events = [];

  ClassOverviewManagementPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Event> events = await api_admin.event_list(widget.session, courseTrue: true, courseID: widget.course.id);
    events.sort();

    setState(() {
      _events = events;
    });
  }

  Future<void> _createClass() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          session: widget.session,
          event: Event.fromCourse(widget.course),
          isDraft: true,
          onSubmit: (Session session, Event event) async {
            if (!await api_admin.event_create(session, widget.course.id, event)) return false;
            _update();
            return true;
          },
        ),
      ),
    );
  }

  Future<void> _createClassBatch() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventCreateBatchPage(
          session: widget.session,
          event: Event.fromCourse(widget.course),
          isDraft: true,
          onSubmit: (Session session, Event event) async {
            if (!await api_admin.event_create(session, widget.course.id, event)) return false;
            _update();
            return true;
          },
        ),
      ),
    );
  }

  Future<void> _selectCourseEvent(Event event, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassDetailManagementPage(
          session: widget.session,
          eventID: event.id,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Class Management"),
      ),
      body: AppBody(
        children: <Widget>[
          AppCourseTile(
            course: widget.course,
          ),
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _createClass,
          ),
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreateBatch,
            onPressed: _createClassBatch,
          ),
          AppListView<Event>(
            items: _events,
            itemBuilder: (Event event) {
              return InkWell(
                onTap: () => _selectCourseEvent(event, false),
                child: AppEventTile(
                  event: event,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
