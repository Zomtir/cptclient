import 'package:cptclient/api/admin/event/event.dart' as api_admin;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/EventCreateBatchPage.dart';
import 'package:cptclient/pages/EventCreatePage.dart';
import 'package:cptclient/pages/EventDetailPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ClassOverviewManagementPage extends StatefulWidget {
  final UserSession session;
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
        builder: (context) => EventCreatePage(
          session: widget.session,
          event: Event.fromCourse(widget.course),
          onSubmit: (UserSession session, Event event) async {
            var result = await api_admin.event_create(session, event, widget.course.id);
            if (result is Failure) return Failure();
            _update();
            return Success(());
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
          onSubmit: (UserSession session, Event event) async {
            var result = await api_admin.event_create(session, event, widget.course.id);
            if (result is! Success) return false;
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
        builder: (context) => EventDetailPage(
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
          widget.course.buildCard(context),
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
            itemBuilder: (Event event) => event.buildTile(
              context,
              onTap: () => _selectCourseEvent(event, false),
            ),
          ),
        ],
      ),
    );
  }
}
