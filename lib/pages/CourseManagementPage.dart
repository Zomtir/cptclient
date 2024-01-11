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
import 'package:cptclient/material/FilterToggle.dart';
import 'package:cptclient/material/Tribox.dart';
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
  final DropdownController<User> _ctrlModerator = DropdownController<User>(items: []);
  bool? _ctrlPublic;
  bool? _ctrlActive;
  final DropdownController<Branch> _ctrlBranch = DropdownController<Branch>(items: server.cacheBranches);
  RangeValues _ctrlThresholdRange = RangeValues(0, 10);

  CourseManagementPageState();

  @override
  void initState() {
    super.initState();
    _requestUsers();
    _update();
  }

  Future<void> _requestUsers() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    setState(() {
      _ctrlModerator.items = users;
    });
  }

  Future<void> _update() async {
    _courses = await server.course_list(widget.session, _ctrlModerator.value, _ctrlActive, _ctrlPublic);
    setState(() => _courses.sort());
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
          AppButton(
            leading: Icon(Icons.add),
            text: "New course",
            onPressed: () => _selectCourse(Course.fromVoid(), true),
          ),
          FilterToggle(
            children: [
              AppInfoRow(
                info: Text("Moderator"),
                child: AppDropdown<User>(
                  controller: _ctrlModerator,
                  builder: (User user) {
                    return Text(user.key);
                  },
                  onChanged: (User? user) {
                    setState(() => _ctrlModerator.value = user);
                    _update();
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() => _ctrlModerator.value = null);
                    _update();
                  },
                ),
              ),
              AppInfoRow(
                info: Text("Active"),
                child: Tribox(
                  value: _ctrlActive,
                  onChanged: (bool? active) {
                    setState(() => _ctrlActive = active);
                    _update();
                  },
                ),
              ),
              AppInfoRow(
                info: Text("Public"),
                child: Tribox(
                  value: _ctrlPublic,
                  onChanged: (bool? public) {
                    setState(() => _ctrlPublic = public);
                    _update();
                  },
                ),
              ),
              AppInfoRow(
                info: Text("Branch"),
                child: AppDropdown<Branch>(
                  controller: _ctrlBranch,
                  builder: (Branch branch) {
                    return Text(branch.title);
                  },
                  onChanged: (Branch? branch) {
                    _ctrlBranch.value = branch;
                    _update();
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _ctrlBranch.value = null;
                    _update();
                  },
                ),
              ),
              AppInfoRow(
                info: Text("Thresholds"),
                child: RangeSlider(
                  values: _ctrlThresholdRange,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (RangeValues values) {
                    _ctrlThresholdRange = values;
                    _update();
                  },
                  labels: RangeLabels("${_ctrlThresholdRange.start}", "${_ctrlThresholdRange.end}"),
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
    );
  }
}
