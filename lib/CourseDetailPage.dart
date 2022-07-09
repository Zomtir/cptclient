import 'package:flutter/material.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/app/AppBody.dart';
import 'package:cptclient/material/app/AppInfoRow.dart';
import 'package:cptclient/material/app/AppButton.dart';
import 'package:cptclient/material/app/AppListView.dart';
import 'package:cptclient/material/app/AppDropdown.dart';
import 'package:cptclient/material/app/AppCourseTile.dart';
import 'package:cptclient/material/app/AppSlotTile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CourseSlotDetailPage.dart';

import 'static/navigation.dart' as navi;
import 'static/db.dart' as db;

import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/member.dart';
import 'package:cptclient/json/branch.dart';
import 'package:cptclient/json/access.dart';

class CourseDetailPage extends StatefulWidget {
  final Session session;
  final Course course;
  final void Function() onUpdate;

  CourseDetailPage({Key? key, required this.session, required this.course, required this.onUpdate}) : super(key: key);

  @override
  CourseDetailPageState createState() => CourseDetailPageState();
}

class CourseDetailPageState extends State<CourseDetailPage> {
  List <Slot> _slots = [];
  List <Member> _moderators = [];

  DropdownController<Member> _ctrlModerator = DropdownController<Member>(items: []);

  TextEditingController _ctrlCourseKey = TextEditingController();
  TextEditingController _ctrlCourseTitle = TextEditingController();
  bool                  _ctrlCourseActive = true;
  DropdownController<Access> _ctrlCourseAccess = DropdownController<Access>(items: db.cacheAccess);
  DropdownController<Branch> _ctrlCourseBranch = DropdownController<Branch>(items: db.cacheBranches);
  int                        _pickThresholdValue = 0;

  CourseDetailPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    if (widget.course.id != 0) _getCourseSlots();
    if (widget.course.id != 0) _getCourseModerators();
    if (widget.session.user!.admin_courses) _applyCourse();
    if (widget.session.user!.admin_courses) _getModeratorCandidates();
  }

  void _deleteCourse() async {
    final response = await http.head(
      Uri.http(navi.server, 'course_delete', {'course_id': widget.course.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete course')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted course')));
    widget.onUpdate();
    Navigator.pop(context);
  }

  void _duplicateCourse() {
    Course _course = Course.fromCourse(widget.course);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CourseDetailPage(session: widget.session, course: _course, onUpdate: _update)));
  }

  Future<void> _getCourseSlots() async {
    final response = await http.get(
      Uri.http(navi.server, 'course_slot_list', {'course_id': widget.course.id.toString()}),
      headers: {
        'Token': widget.session.token,
        'Accept': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode != 200) return;

    Iterable l = json.decode(utf8.decode(response.bodyBytes));

    setState(() {
      _slots = List<Slot>.from(l.map((model) => Slot.fromJson(model)));
    });
  }

  void _selectCourseSlot(Slot slot) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseSlotDetailPage(session: widget.session, slot: slot, onUpdate: _getCourseSlots)));
  }

  void _createCourseSlot() async {
    _selectCourseSlot(Slot.fromCourse(widget.course));
  }

  Future<void> _getModeratorCandidates() async {
    final response = await http.get(
      Uri.http(navi.server, 'user_member_list'),
      headers: {
        'Token': widget.session.token,
        'Accept': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode != 200) return;

    Iterable list = json.decode(utf8.decode(response.bodyBytes));
    var members = List<Member>.from(list.map((model) => Member.fromJson(model)));

    setState(() {
      _ctrlModerator.items = members;
    });
  }

  Future<void> _getCourseModerators() async {
    final response = await http.get(
      Uri.http(navi.server, 'course_moderator_list', {'course_id': widget.course.id.toString()}),
      headers: {
        'Token': widget.session.token,
        'Accept': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode != 200) return;

    Iterable list = json.decode(utf8.decode(response.bodyBytes));

    setState(() {
      _moderators = List<Member>.from(list.map((model) => Member.fromJson(model)));
    });
  }

  void _modMember(Member member) async {
    final response = await http.head(
      Uri.http(navi.server, 'course_mod', {
        'course_id': widget.course.id.toString(),
        'user_id' : member.id.toString(),
      }),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add moderator')));
      return;
    }

    _getCourseModerators();
  }

  void _unmodMember(Member member) async {
    final response = await http.head(
      Uri.http(navi.server, 'course_unmod', {
        'course': widget.course.id.toString(),
        'user' : member.id.toString(),
      }),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove moderator')));
      return;
    }

    _getCourseModerators();
  }

  void _applyCourse() {
    _ctrlCourseKey.text = widget.course.key;
    _ctrlCourseTitle.text = widget.course.title;
    _ctrlCourseActive = widget.course.active;
    _ctrlCourseAccess.value = widget.course.access;
    _ctrlCourseBranch.value = widget.course.branch;
    _pickThresholdValue = widget.course.threshold;
  }

  void _gatherCourse() {
    widget.course.key = _ctrlCourseKey.text;
    widget.course.title = _ctrlCourseTitle.text;
    widget.course.active = _ctrlCourseActive;
    widget.course.access = _ctrlCourseAccess.value;
    widget.course.branch = _ctrlCourseBranch.value;
    widget.course.threshold = _pickThresholdValue;
  }

  void _submitCourse() async {
    _gatherCourse();

    final response = await http.post(
      Uri.http(navi.server, widget.course.id == 0 ? 'course_create' : 'course_edit'),
      headers: {
        'Token': widget.session.token,
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: json.encode(widget.course),
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit course')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully edited course')));
    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Course Details"),
      ),
      body: AppBody(
        children: <Widget>[
          if (widget.course.id != 0) Row(
            children: [
              Expanded(
                child: AppCourseTile(
                  onTap: (course) => {},
                  course: widget.course,
                ),
              ),
              if (widget.session.user!.admin_courses) IconButton(
                icon: const Icon(Icons.copy),
                onPressed: _duplicateCourse,
              ),
              if (widget.session.user!.admin_courses) IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteCourse,
              ),
            ],
          ),
          PanelSwiper(
            panels: [
              if (widget.course.id != 0) Panel("Slots", _buildSlotPanel()),
              if (widget.course.id != 0) Panel("Moderators", _buildModeratorPanel()),
              if (widget.session.user!.admin_courses) Panel("Edit", buildEditPanel()),
            ]
          ),
        ],
      ),
    );
  }

  Widget _buildSlotPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: "\u{2795} New slot",
          onPressed: _createCourseSlot,
        ),
        AppListView<Slot>(
          items: _slots,
          itemBuilder: (Slot slot) {
            return AppSlotTile(
              onTap: _selectCourseSlot,
              slot: slot,
            );
          },
        ),
      ],
    );
  }

  Widget _buildModeratorPanel() {
    return Column(
      children: [
        if(widget.session.user!.admin_courses) AppDropdown<Member>(
          hint: Text("Add moderator"),
          controller: _ctrlModerator,
          builder: (Member member) {return Text(member.key);},
          onChanged: (Member? member) => _modMember(member!),
        ),
        AppListView<Member>(
          items: _moderators,
          itemBuilder: (Member member) {
            return InkWell(
              child: ListTile(
                title: Text("${member.lastname}, ${member.firstname}"),
                subtitle: Text("${member.key}"),
                  trailing: !widget.session.user!.admin_courses ? null :  IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _unmodMember(member),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildEditPanel() {
    return Column(
      children: [
        AppInfoRow(
          info: Text("Key"),
          child: TextField(
            maxLines: 1,
            controller: _ctrlCourseKey,
          ),
        ),
        AppInfoRow(
          info: Text("Title"),
          child: TextField(
            maxLines: 1,
            controller: _ctrlCourseTitle,
          ),
        ),
        AppInfoRow(
          info: Text("Active"),
          child: Checkbox(
            value: _ctrlCourseActive,
            onChanged: (bool? active) =>  setState(() => _ctrlCourseActive = active!),
          ),
        ),
        AppInfoRow(
          info: Text("Access"),
          child: AppDropdown<Access>(
            hint: Text("Access"),
            controller: _ctrlCourseAccess,
            builder: (Access access) => Text(access.title),
            onChanged: (Access? access) => setState(() => _ctrlCourseAccess.value = access),
          ),
        ),
        AppInfoRow(
          info: Text("Branch"),
          child: AppDropdown<Branch>(
            hint: Text("Branch"),
            controller: _ctrlCourseBranch,
            builder: (Branch branch) => Text(branch.title),
            onChanged: (Branch? branch) => setState(() => _ctrlCourseBranch.value = branch),
          ),
        ),
        AppInfoRow(
            info: Text("Level"),
            child: Slider(
              value: _pickThresholdValue.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (double value) {
                setState(() => _pickThresholdValue = value.toInt());
              },
              label: "$_pickThresholdValue",
            )
        ),
        AppButton(
          text: "Save",
          onPressed: _submitCourse,
        ),
      ],
    );
  }

}
