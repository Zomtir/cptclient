import 'package:cptclient/json/branch.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/CollapseWidget.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/CourseClassMangementPage.dart';
import 'package:cptclient/pages/CourseEditPage.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_course_admin.dart' as server;
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:flutter/material.dart';

class CourseManagementPage extends StatefulWidget {
  final Session session;

  CourseManagementPage({super.key, required this.session});

  @override
  CourseManagementPageState createState() => CourseManagementPageState();
}

class CourseManagementPageState extends State<CourseManagementPage> {
  List<Course> _courses = [];
  final DropdownController<User> _ctrlDropdownModerators = DropdownController<User>(items: []);

  List<Course> _coursesFiltered = [];
  bool _hideFilters = true;
  bool _isActive = true;
  bool _isPublic = true;
  final DropdownController<Branch> _ctrlDropdownBranch = DropdownController<Branch>(items: server.cacheBranches);
  RangeValues _thresholdRange = RangeValues(0, 10);

  CourseManagementPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _requestUsers();
    _requestCourses(null);
  }

  Future<void> _requestUsers() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    setState(() {
      _ctrlDropdownModerators.items = users;
    });
  }

  Future<void> _requestCourses(User? user) async {
    _courses = await server.course_list(widget.session, user);
    _courses.sort();
    setState(() => _ctrlDropdownModerators.value = user);
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
        builder: (context) => CourseClassManagementPage(session: widget.session, course: course, isDraft: isDraft),
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
          onSubmit: server.course_create,
        ),
      ),
    );

    _update();
  }

  Future<void> _duplicateCourse(Course course) async {
    Course _course = Course.fromCourse(course);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseEditPage(
          session: widget.session,
          course: _course,
          isDraft: true,
          onSubmit: server.course_create,
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
            onPressed: () => _selectCourse(Course.fromVoid(), true),
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
                info: Text("Public"),
                child: Checkbox(
                  value: _isPublic,
                  onChanged: (bool? public) {
                    _isPublic = public!;
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
    );
  }
}
