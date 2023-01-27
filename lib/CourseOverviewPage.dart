import 'package:flutter/material.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/CollapseWidget.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppDropdown.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CourseInfoPage.dart';

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
  List <Course> _modcourses = [];
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
    _getAvailableCourses();
    _getResponsibleCourses();
  }

  Future<void> _getAvailableCourses() async {
    final response = await http.get(
      Uri.http(navi.serverURL, '/member/course_availiblity'),
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

  Future<void> _getResponsibleCourses() async {
    final response = await http.get(
      Uri.http(navi.serverURL, '/mod/course_responsibility'),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    Iterable l = json.decode(response.body);

    _modcourses = List<Course>.from(l.map((model) => Course.fromJson(model)));
    _filterCourses();
  }

  void _filterCourses() {
    setState(() {
      _coursesFiltered = _modcourses.where((course) {
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

  void _selectCourse(Course course) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseInfoPage(session: widget.session, course: course, onUpdate: _update)));
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Your Courses"),
      ),
      body: AppBody(
        children: [
          PanelSwiper(
              panels: [
                Panel("Available", _buildOwnCoursePanel()),
                Panel("Moderated", _buildModCoursePanel()),
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

  Widget _buildModCoursePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
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
