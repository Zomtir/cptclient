import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class CourseEditPage extends StatefulWidget {
  final UserSession session;
  final Course course;
  final bool isDraft;
  final Future<bool> Function(UserSession, Course) onSubmit;
  final Future<bool> Function(UserSession, Course)? onDelete;

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
    if (_ctrlCourseKey.text.isEmpty || _ctrlCourseKey.text.length > 10) {
      messageText("${AppLocalizations.of(context)!.courseKey} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    if (_ctrlCourseTitle.text.isEmpty || _ctrlCourseTitle.text.length > 100) {
      messageText("${AppLocalizations.of(context)!.userLastname} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    _gatherCourse();

    bool success;
    if (widget.isDraft) {
      success = await api_admin.course_create(widget.session, widget.course);
    } else {
      success = await api_admin.course_edit(widget.session, widget.course);
    }

    messageFailureOnly(success);
    if (!success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseEdit),
        actions: [
          if (!widget.isDraft && widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteCourse,
            ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          if (!widget.isDraft) widget.course.buildCard(context),
          AppInfoRow(
            info: AppLocalizations.of(context)!.courseKey,
            child: TextField(
              maxLines: 1,
              controller: _ctrlCourseKey,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.courseTitle,
            child: TextField(
              maxLines: 1,
              controller: _ctrlCourseTitle,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.courseActive,
            child: Checkbox(
              value: _ctrlCourseActive,
              onChanged: (bool? active) => setState(() => _ctrlCourseActive = active!),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.coursePublic,
            child: Checkbox(
              value: _ctrlCoursePublic,
              onChanged: (bool? public) => setState(() => _ctrlCoursePublic = public!),
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionConfirm,
            onPressed: _submitCourse,
          ),
        ],
      ),
    );
  }
}
