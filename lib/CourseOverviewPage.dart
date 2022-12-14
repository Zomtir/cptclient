import 'package:flutter/material.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/CollapseWidget.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/app/AppBody.dart';
import 'package:cptclient/material/app/AppButton.dart';
import 'package:cptclient/material/app/AppInfoRow.dart';
import 'package:cptclient/material/app/AppDropdown.dart';
import 'package:cptclient/material/app/AppListView.dart';
import 'package:cptclient/material/app/AppCourseTile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CourseDetailPage.dart';

import 'static/navigation.dart' as navi;
import 'static/db.dart' as db;

import 'json/session.dart';
import 'json/course.dart';
import 'json/branch.dart';
import 'json/access.dart';

class CourseOverviewPage extends StatefulWidget {
  final Session session;

  CourseOverviewPage({Key? key, required this.session}) : super(key: key);

  @override
  CourseOverviewPageState createState() => CourseOverviewPageState();
}

class CourseOverviewPageState extends State<CourseOverviewPage> {
  List <Course> _owncourses = [];
  List <Course> _courses = [];
  List <Course> _coursesFiltered = [];
  bool          _hideFilters = true;

  bool                       _isActive = true;
  DropdownController<Access> _ctrlDropdownAccess = DropdownController<Access>(items: db.cacheAccess);
  DropdownController<Branch> _ctrlDropdownBranch = DropdownController<Branch>(items: db.cacheBranches);
  RangeValues                _thresholdRange = RangeValues(0, 10);

  CourseOverviewPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _getOwnCourses();
    if(widget.session.user!.admin_courses) _getAllCourses();
  }

  Future<void> _getOwnCourses() async {
    final response = await http.get(
      Uri.http(navi.server, 'user_course_list'),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    Iterable list = json.decode(response.body);

    setState(() {
      _owncourses = List<Course>.from(list.map((model) => Course.fromJson(model)));
    });
  }

  Future<void> _getAllCourses() async {
    final response = await http.get(
      Uri.http(navi.server, 'course_list', {'user_id': '0'}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    Iterable l = json.decode(response.body);

    _courses = List<Course>.from(l.map((model) => Course.fromJson(model)));
    _filterCourses();
  }

  void _filterCourses() {
    setState(() {
      _coursesFiltered = _courses.where((course) {
        bool activeFilter = course.active == _isActive;
        bool accessFilter = (_ctrlDropdownAccess.value == null) ? true : (course.access == _ctrlDropdownAccess.value);
        bool branchFilter = (_ctrlDropdownBranch.value == null) ? true : (
          course.branch == _ctrlDropdownBranch.value &&
          course.threshold >= _thresholdRange.start &&
          course.threshold <= _thresholdRange.end
        );
        return activeFilter && accessFilter && branchFilter;
      }).toList();
    });
  }

  void _createCourse() async {
    Course course = Course.fromVoid();

    _selectCourse(course);
  }

  void _selectCourse(Course course) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailPage(session: widget.session, course: course, onUpdate: _update)));
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Course Overview"),
      ),
      body: AppBody(
        children: [
          PanelSwiper(
              panels: [
                Panel("Own Courses", _buildOwnCoursePanel()),
                if(widget.session.user!.admin_courses) Panel("All Courses", _buildAllCoursePanel()),
              ]
          ),
        ],
      ),
    );
  }

  Widget _buildOwnCoursePanel() {
    return AppListView(
      items: _owncourses,
      itemBuilder: (Course course) {
        return AppCourseTile(
          onTap: _selectCourse,
          course: course,
        );
      },
    );
  }

  Widget _buildAllCoursePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppButton(
          leading: Icon(Icons.add),
          text: "New course",
          onPressed: _createCourse,
        ),
        TextButton.icon(
          icon: _hideFilters ? Icon(Icons.keyboard_arrow_down) : Icon(Icons.keyboard_arrow_up),
          label: _hideFilters ? Text('Show Filters') : Text ('Hide Filters'),
          onPressed: () => setState (() => _hideFilters = !_hideFilters),
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
                builder: (Access access) {return Text(access.title);},
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
                builder: (Branch branch) {return Text(branch.title);},
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
                labels: RangeLabels("${_thresholdRange.start}","${_thresholdRange.end}"),
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
    );
  }


}
