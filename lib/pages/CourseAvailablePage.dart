import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/ClassOverviewAvailablePage.dart';
import 'package:cptclient/api/regular/course/course.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseAvailablePage extends StatefulWidget {
  final UserSession session;

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
        builder: (context) => ClassOverviewAvailablePage(
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
