import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/ClassAvailablePage.dart';
import 'package:cptclient/static/server_course_regular.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseAvailablePage extends StatefulWidget {
  final Session session;

  CourseAvailablePage({super.key, required this.session});

  @override
  CourseAvailablePageState createState() => CourseAvailablePageState();
}

class CourseAvailablePageState extends State<CourseAvailablePage> {
  List<Course> _courses = [];

  CourseAvailablePageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<Course>? courses = await server.course_availability(widget.session);
    setState(() => _courses = courses!);
  }

  Future<void> _selectCourse(Course course, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassAvailablePage(
          session: widget.session,
          course: course,
        ),
      ),
    );
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseAvailable),
      ),
      body: AppBody(
        children: [
          AppListView(
            items: _courses,
            itemBuilder: (Course course) {
              return InkWell(
                onTap: () => _selectCourse(course, false),
                child: AppCourseTile(
                  course: course,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
