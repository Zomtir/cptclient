import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:flutter/material.dart';

class EventCourseEditPage extends StatefulWidget {
  final UserSession session;
  final Event event;
  final Future<List<Course>> Function() callList;
  final Future<int?> Function() callInfo;
  final Future<void> Function(Course?) callEdit;

  EventCourseEditPage(
      {super.key,
      required this.session,
      required this.event,
      required this.callList,
      required this.callInfo,
      required this.callEdit});

  @override
  EventCourseEditPageState createState() => EventCourseEditPageState();
}

class EventCourseEditPageState extends State<EventCourseEditPage> {
  final DropdownController<Course> _ctrlCourse = DropdownController<Course>(items: []);

  EventCourseEditPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  _update() async {
    List<Course> courses = await widget.callList();
    int? courseID = await widget.callInfo();

    setState(() {
      _ctrlCourse.items = courses;
      _ctrlCourse.value = (courseID == null) ? null : courses.firstWhere((course) => course.id == courseID);
    });
  }

  Future<void> _handleCourse(Course? course) async {
    await widget.callEdit(course);
    setState(() => _ctrlCourse.value = course);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventCourse),
      ),
      body: AppBody(
        children: [
          AppEventTile(
            event: widget.event,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.course,
            child: AppDropdown<Course>(
              controller: _ctrlCourse,
              builder: (Course course) => Text(course.title),
              onChanged: (course) => _handleCourse(course),
            ),
          ),
        ],
      ),
    );
  }
}
