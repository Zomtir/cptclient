import 'package:flutter/material.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/CollapseWidget.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppDropdown.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';

import 'CourseMemberPage.dart';

import '../static/server.dart' as server;
import '../static/serverCourseModerator.dart' as server;

import '../json/session.dart';
import '../json/course.dart';
import '../json/branch.dart';

class CourseResponsiblePage extends StatefulWidget {
  final Session session;

  CourseResponsiblePage({Key? key, required this.session}) : super(key: key);

  @override
  CourseResponsiblePageState createState() => CourseResponsiblePageState();
}

class CourseResponsiblePageState extends State<CourseResponsiblePage> {
  List<Course> _courses = [];
  List<Course> _coursesFiltered = [];
  bool _hideFilters = true;

  bool _isActive = true;
  bool _isPublic = true;
  DropdownController<Branch> _ctrlDropdownBranch = DropdownController<Branch>(items: server.cacheBranches);
  RangeValues _thresholdRange = RangeValues(0, 10);

  CourseResponsiblePageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<Course>? courses = await server.course_responsibility(widget.session);
    _courses = courses!;
    _filterCourses();
  }

  void _filterCourses() {
    setState(() {
      _coursesFiltered = _courses.where((course) {
        bool activeFilter = course.active == _isActive;
        bool publicFilter = course.public == _isPublic;
        bool branchFilter =
        (_ctrlDropdownBranch.value == null) ? true : (course.branch == _ctrlDropdownBranch.value && course.threshold >= _thresholdRange.start && course.threshold <= _thresholdRange.end);
        return activeFilter && publicFilter && branchFilter;
      }).toList();
    });
  }

  Future<void> _selectCourse(Course course, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CourseMemberPage(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton.icon(
                icon: _hideFilters ? Icon(Icons.keyboard_arrow_down) : Icon(Icons.keyboard_arrow_up),
                label: _hideFilters ? Text('Show Filters') : Text('Hide Filters'),
                onPressed: () => setState(() => _hideFilters = !_hideFilters),
              ),
              CollapseWidget(
                collapse: _hideFilters,
                children: [
                  AppInfoRow(
                    info: Text("Active"),
                    child: Checkbox(
                      value: _isActive,
                      onChanged: (bool? active) {
                        _isActive = active!;
                        _filterCourses();
                      },
                    ),
                  ),
                  AppInfoRow(
                    info: Text("Public"),
                    child: Checkbox(
                      value: _isPublic,
                      onChanged: (bool? public) {
                        _isActive = public!;
                        _filterCourses();
                      },
                    ),
                  ),
                  AppInfoRow(
                    info: Text("Branch"),
                    child: AppDropdown<Branch>(
                      controller: _ctrlDropdownBranch,
                      builder: (Branch branch) {
                        return Text(branch.title);
                      },
                      onChanged: (Branch? branch) {
                        _ctrlDropdownBranch.value = branch;
                        _filterCourses();
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _ctrlDropdownBranch.value = null;
                        _filterCourses();
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
                        _filterCourses();
                      },
                      labels: RangeLabels("${_thresholdRange.start}", "${_thresholdRange.end}"),
                    ),
                  ),
                ],
              ),
              AppListView<Course>(
                items: _coursesFiltered,
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
