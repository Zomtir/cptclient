import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/FilterToggle.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/CourseModeratorPage.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_course_moderator.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseResponsiblePage extends StatefulWidget {
  final Session session;

  CourseResponsiblePage({super.key, required this.session});

  @override
  CourseResponsiblePageState createState() => CourseResponsiblePageState();
}

class CourseResponsiblePageState extends State<CourseResponsiblePage> {
  List<Course> _courses = [];

  bool _isActive = true;
  bool _isPublic = true;
  final DropdownController<Skill> _ctrlDropdownBranch = DropdownController<Skill>(items: server.cacheSkills);
  RangeValues _thresholdRange = RangeValues(0, 10);

  CourseResponsiblePageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<Course> courses = await server.course_responsibility(widget.session, _isActive, _isPublic);

    setState(() => _courses = courses);
  }

  Future<void> _selectCourse(Course course, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CourseModeratorPage(
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
                    info: Text("Active"),
                    child: Checkbox(
                      value: _isActive,
                      onChanged: (bool? active) {
                        _isActive = active!;
                      },
                    ),
                  ),
                  AppInfoRow(
                    info: Text("Public"),
                    child: Checkbox(
                      value: _isPublic,
                      onChanged: (bool? public) {
                        _isPublic = public!;
                      },
                    ),
                  ),
                  AppInfoRow(
                    info: Text("Branch"),
                    child: AppDropdown<Skill>(
                      controller: _ctrlDropdownBranch,
                      builder: (Skill branch) {
                        return Text(branch.title);
                      },
                      onChanged: (Skill? branch) {
                        _ctrlDropdownBranch.value = branch;
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _ctrlDropdownBranch.value = null;
                      },
                    ),
                  ),
                  AppInfoRow(
                    info: Text("Thresholds"),
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
