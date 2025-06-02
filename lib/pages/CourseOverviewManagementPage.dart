import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/api/anon/skill.dart' as api_anon;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/json/valence.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/ChoiceDisplay.dart';
import 'package:cptclient/material/dialogs/ChoiceEdit.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/fields/SkillRangeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/FilterToggle.dart';
import 'package:cptclient/pages/CourseDetailMangementPage.dart';
import 'package:cptclient/pages/CourseEditPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class CourseOverviewManagementPage extends StatefulWidget {
  final UserSession session;

  CourseOverviewManagementPage({super.key, required this.session});

  @override
  CourseOverviewManagementPageState createState() => CourseOverviewManagementPageState();
}

class CourseOverviewManagementPageState extends State<CourseOverviewManagementPage> {
  List<Course> _courses = [];
  final FieldController<User> _ctrlModerator = FieldController<User>();
  Valence? _ctrlPublic;
  Valence? _ctrlActive;
  final FieldController<Skill> _ctrlSkill = FieldController<Skill>();
  RangeValues _ctrlSkillRange = RangeValues(0, 10);

  CourseOverviewManagementPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    _ctrlSkill.callItems = () => api_anon.skill_list();
    _ctrlModerator.callItems = () => api_regular.user_list(widget.session);

    Result<List<Course>> result = await api_admin.course_list(widget.session, user: _ctrlModerator.value, active: _ctrlActive?.toBool(), public: _ctrlPublic?.toBool());
    if (result is! Success) return;

    _courses = result.unwrap();
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
        title: Text(AppLocalizations.of(context)!.pageCourseManagement),
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
                info: AppLocalizations.of(context)!.courseModerator,
                child: AppField<User>(
                  controller: _ctrlModerator,
                  onChanged: (User? user) => setState(() => _ctrlModerator.value = user),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.courseActive,
                child: ListTile(
                  title: ChoiceDisplay(
                    value: _ctrlActive,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<Valence?>(
                      context: context,
                      widget: ChoiceEdit(value: _ctrlActive),
                      onChanged: (Valence? v) => setState(() => _ctrlActive = v),
                    ),
                  ),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.coursePublic,
                child: ListTile(
                  title: ChoiceDisplay(
                    value: _ctrlPublic,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<Valence?>(
                      context: context,
                      widget: ChoiceEdit(value: _ctrlPublic),
                      onChanged: (Valence? v) => setState(() => _ctrlPublic = v),
                    ),
                  ),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.skill,
                child: SkillRangeField(
                  controller: _ctrlSkill,
                  range: _ctrlSkillRange,
                  onChanged: (Skill? skill, RangeValues range) => setState(() {
                    _ctrlSkill.value = skill;
                    _ctrlSkillRange = range;
                  }),
                ),
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
