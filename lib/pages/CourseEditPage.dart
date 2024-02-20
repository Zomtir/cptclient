import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/static/server_course_admin.dart' as api_admin;
import 'package:flutter/material.dart';

class CourseEditPage extends StatefulWidget {
  final Session session;
  final Course course;
  final bool isDraft;
  final Future<bool> Function(Session, Course) onSubmit;
  final Future<bool> Function(Session, Course)? onDelete;

  CourseEditPage({super.key, required this.session, required this.course, required this.isDraft, required this.onSubmit, this.onDelete});

  @override
  CourseEditPageState createState() => CourseEditPageState();
}

class CourseEditPageState extends State<CourseEditPage> {
  final TextEditingController _ctrlCourseKey = TextEditingController();
  final TextEditingController _ctrlCourseTitle = TextEditingController();
  bool _ctrlCourseActive = true;
  bool _ctrlCoursePublic = true;

  CourseEditPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _applyCourse();
  }

  void _deleteCourse() async {
    if (!await widget.onDelete!(widget.session, widget.course)) return;

    Navigator.pop(context);
  }

  void _applyCourse() {
    _ctrlCourseKey.text = widget.course.key;
    _ctrlCourseTitle.text = widget.course.title;
    _ctrlCourseActive = widget.course.active;
    _ctrlCoursePublic = widget.course.public;
  }

  void _gatherCourse() {
    widget.course.key = _ctrlCourseKey.text;
    widget.course.title = _ctrlCourseTitle.text;
    widget.course.active = _ctrlCourseActive;
    widget.course.public = _ctrlCoursePublic;
  }

  void _submitCourse() async {
    _gatherCourse();

    bool success;
    if (widget.isDraft) {
      success = await api_admin.course_create(widget.session, widget.course);
    } else {
      success = await api_admin.course_edit(widget.session, widget.course);
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit course')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully edited course')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Edit"),
      ),
      body: AppBody(
        children: <Widget>[
          if (!widget.isDraft)
            AppCourseTile(
              course: widget.course,
              trailing: [
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteCourse,
                  ),
              ],
            ),
          AppInfoRow(
            info: Text("Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlCourseKey,
            ),
          ),
          AppInfoRow(
            info: Text("Title"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlCourseTitle,
            ),
          ),
          AppInfoRow(
            info: Text("Active"),
            child: Checkbox(
              value: _ctrlCourseActive,
              onChanged: (bool? active) => setState(() => _ctrlCourseActive = active!),
            ),
          ),
          AppInfoRow(
            info: Text("Public"),
            child: Checkbox(
              value: _ctrlCoursePublic,
              onChanged: (bool? public) => setState(() => _ctrlCoursePublic = public!),
            ),
          ),
          AppButton(
            text: "Save",
            onPressed: _submitCourse,
          ),
        ],
      ),
    );
  }
}
