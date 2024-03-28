import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/FilterToggle.dart';
import 'package:cptclient/material/Tribox.dart';
import 'package:cptclient/material/dropdowns/RankingDropdown.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/CourseDetailMangementPage.dart';
import 'package:cptclient/pages/CourseEditPage.dart';
import 'package:cptclient/static/server_course_admin.dart' as api_admin;
import 'package:cptclient/static/server_skill_anon.dart' as api_anon;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseManagementPage extends StatefulWidget {
  final Session session;

  CourseManagementPage({super.key, required this.session});

  @override
  CourseManagementPageState createState() => CourseManagementPageState();
}

class CourseManagementPageState extends State<CourseManagementPage> {
  List<Course> _courses = [];
  final FieldController<User> _ctrlModerator = FieldController<User>();
  bool? _ctrlPublic;
  bool? _ctrlActive;
  final FieldController<Skill> _ctrlSkill = FieldController<Skill>();
  RangeValues _ctrlSkillRange = RangeValues(0, 10);

  CourseManagementPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    _ctrlSkill.callItems = () => api_anon.skill_list();
    _ctrlModerator.callItems = () => api_regular.user_list(widget.session);

    _courses = await api_admin.course_list(widget.session, _ctrlModerator.value, _ctrlActive, _ctrlPublic);
    setState(() => _courses.sort());
  }

  Future<void> _selectCourse(Course course) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailManagementPage(session: widget.session, course: course, isDraft: false),
      ),
    );

    _update();
  }

  Future<void> _createCourse() async {
    Course course = Course.fromVoid();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseEditPage(
          session: widget.session,
          course: course,
          isDraft: true,
          onSubmit: api_admin.course_create,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Management"),
      ),
      body: AppBody(
        children: [
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _createCourse,
          ),
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.courseModerator),
                child: AppField<User>(
                  controller: _ctrlModerator,
                  onChanged: (User? user) => setState(() => _ctrlModerator.value = user),
                ),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.courseActive),
                child: Tribox(
                  value: _ctrlActive,
                  onChanged: (bool? active) => setState(() => _ctrlActive = active),
                ),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.coursePublic),
                child: Tribox(
                  value: _ctrlPublic,
                  onChanged: (bool? public) => setState(() => _ctrlPublic = public),
                ),
              ),
              CompetenceDropdown(
                controller: _ctrlSkill,
                range: _ctrlSkillRange,
                onChanged: (Skill? branch, RangeValues range) => setState(() {
                  _ctrlSkill.value = branch;
                  _ctrlSkillRange = range;
                }),
              ),
            ],
          ),
          AppListView<Course>(
            items: _courses,
            itemBuilder: (Course course) {
              return InkWell(
                onTap: () => _selectCourse(course),
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
