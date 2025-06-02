import 'package:cptclient/api/anon/skill.dart' as api_anon;
import 'package:cptclient/api/moderator/course/imports.dart' as api_moderator;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:cptclient/material/widgets/FilterToggle.dart';
import 'package:cptclient/pages/CourseDetailModerationPage.dart';
import 'package:flutter/material.dart';

class CourseOverviewModerationPage extends StatefulWidget {
  final UserSession session;

  CourseOverviewModerationPage({super.key, required this.session});

  @override
  CourseOverviewModerationPageState createState() => CourseOverviewModerationPageState();
}

class CourseOverviewModerationPageState extends State<CourseOverviewModerationPage> {
  List<Course> _courses = [];

  bool _isActive = true;
  bool _isPublic = true;
  final DropdownController<Skill> _ctrlDropdownSkill = DropdownController<Skill>(items: []);
  RangeValues _thresholdRange = RangeValues(0, 10);

  CourseOverviewModerationPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<Skill> skills = await api_anon.skill_list();
    List<Course> courses = await api_moderator.course_responsibility(widget.session, _isActive, _isPublic);

    setState(() {
      _ctrlDropdownSkill.items = skills;
      _courses = courses;
    });
  }

  Future<void> _selectCourse(Course course, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailModerationPage(
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseResponsible),
      ),
      body: AppBody(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FilterToggle(
                onApply: _update,
                children: [
                  AppInfoRow(
                    info: AppLocalizations.of(context)!.courseActive,
                    child: Checkbox(
                      value: _isActive,
                      onChanged: (bool? active) {
                        _isActive = active!;
                      },
                    ),
                  ),
                  AppInfoRow(
                    info: AppLocalizations.of(context)!.coursePublic,
                    child: Checkbox(
                      value: _isPublic,
                      onChanged: (bool? public) {
                        _isPublic = public!;
                      },
                    ),
                  ),
                  AppInfoRow(
                    info: AppLocalizations.of(context)!.skill,
                    child: ListTile(
                      title: AppDropdown<Skill>(
                        controller: _ctrlDropdownSkill,
                        builder: (Skill skill) {
                          return Text(skill.title);
                        },
                        onChanged: (Skill? skill) {
                          _ctrlDropdownSkill.value = skill;
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _ctrlDropdownSkill.value = null;
                        },
                      ),
                    ),
                  ),
                  AppInfoRow(
                    info: AppLocalizations.of(context)!.skillRange,
                    child: RangeSlider(
                      values: _thresholdRange,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (RangeValues values) {
                        _thresholdRange = values;
                      },
                      labels: RangeLabels("${_thresholdRange.start}", "${_thresholdRange.end}"),
                    ),
                  ),
                ],
              ),
              AppListView<Course>(
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
        ],
      ),
    );
  }
}
