import 'package:cptclient/api/admin/event/imports.dart' as api_admin;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/static/server_course_anon.dart' as api_anon;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventCourseEditPage extends StatefulWidget {
  final UserSession session;
  final Event event;
  
  EventCourseEditPage({super.key, required this.session, required this.event});

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
    List<Course> courses = await api_anon.course_list();
    int? courseID = await api_admin.event_course_info(widget.session, widget.event);

    setState(() {
      _ctrlCourse.items = courses;
      _ctrlCourse.value = (courseID == null) ? null : courses.firstWhere((course) => course.id == courseID);
    });
  }

  Future<void> _handleCourse(Course? course) async {
    await api_admin.event_course_edit(widget.session, widget.event, course);
    setState(() => _ctrlCourse.value = course);
  }

  @override
  Widget build (BuildContext context) {
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
