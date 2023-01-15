import 'package:cptclient/static/serverCourseAdmin.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/CollapseWidget.dart';
import 'package:cptclient/material/app/AppBody.dart';
import 'package:cptclient/material/app/AppButton.dart';
import 'package:cptclient/material/app/AppInfoRow.dart';
import 'package:cptclient/material/app/AppDropdown.dart';
import 'package:cptclient/material/app/AppListView.dart';
import 'package:cptclient/material/app/AppCourseTile.dart';

import 'CourseAdminPage.dart';

import 'static/db.dart' as db;

import 'json/session.dart';
import 'json/course.dart';
import 'json/branch.dart';
import 'json/access.dart';
import 'json/user.dart';

class CourseManagementPage extends StatefulWidget {
  final Session session;

  CourseManagementPage({Key? key, required this.session}) : super(key: key);

  @override
  CourseManagementPageState createState() => CourseManagementPageState();
}

class CourseManagementPageState extends State<CourseManagementPage> {
  List<Course> _courses = [];
  DropdownController<User> _ctrlDropdownModerators = DropdownController<User>(items: db.cacheMembers);

  List<Course> _coursesFiltered = [];
  bool _hideFilters = true;
  bool _isActive = true;
  DropdownController<Access> _ctrlDropdownAccess = DropdownController<Access>(items: db.cacheAccess);
  DropdownController<Branch> _ctrlDropdownBranch = DropdownController<Branch>(items: db.cacheBranches);
  RangeValues _thresholdRange = RangeValues(0, 10);

  CourseManagementPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _requestCourses(null);
  }

  Future<void> _requestCourses(User? user) async {
    _courses = await course_list(widget.session, user);
    setState(() => _ctrlDropdownModerators.value = user);
    _filterCourses();
  }

  void _filterCourses() {
    setState(() {
      _coursesFiltered = _courses.where((course) {
        bool activeFilter = course.active == _isActive;
        bool accessFilter = (_ctrlDropdownAccess.value == null) ? true : (course.access == _ctrlDropdownAccess.value);
        bool branchFilter =
            (_ctrlDropdownBranch.value == null) ? true : (course.branch == _ctrlDropdownBranch.value && course.threshold >= _thresholdRange.start && course.threshold <= _thresholdRange.end);
        return activeFilter && accessFilter && branchFilter;
      }).toList();
    });
  }

  void _createCourse() async {
    Course course = Course.fromVoid();
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseAdminPage(session: widget.session, course: course, onUpdate: _update, isDraft: true)));
  }

  void _selectCourse(Course course) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseAdminPage(session: widget.session, course: course, onUpdate: _update, isDraft: false)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Course Management"),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: Text("User"),
            child: AppDropdown<User>(
              controller: _ctrlDropdownModerators,
              builder: (User user) {
                return Text(user.key);
              },
              onChanged: (User? user) => _requestCourses(user),
            ),
            trailing: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => _requestCourses(null),
            ),
          ),
          AppButton(
            leading: Icon(Icons.add),
            text: "New course",
            onPressed: _createCourse,
          ),
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
                info: Text("Access"),
                child: AppDropdown<Access>(
                  controller: _ctrlDropdownAccess,
                  builder: (Access access) {
                    return Text(access.title);
                  },
                  onChanged: (Access? access) {
                    _ctrlDropdownAccess.value = access;
                    _filterCourses();
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _ctrlDropdownAccess.value = null;
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
              return AppCourseTile(
                onTap: _selectCourse,
                course: course,
              );
            },
          ),
        ],
      ),
    );
  }
}
