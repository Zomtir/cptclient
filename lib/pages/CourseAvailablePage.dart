import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';

import 'CourseMemberPage.dart';

import '../static/serverCourseMember.dart' as server;

import '../json/session.dart';
import '../json/course.dart';

class CourseAvailablePage extends StatefulWidget {
  final Session session;

  CourseAvailablePage({Key? key, required this.session}) : super(key: key);

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
    List<Course>? courses = await server.course_availiblity(widget.session);
    setState(() => _courses = courses!);
  }

  Future<void> _selectCourse(Course course, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseMemberPage(
          session: widget.session,
          course: course,
          isDraft: isDraft,
        ),
      ),
    );
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Available Courses"),
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
