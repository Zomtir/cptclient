import 'package:flutter/material.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/AppDropdown.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import '../json/team.dart';
import '../material/panels/SelectionPanel.dart';

import '../material/tiles/AppTeamTile.dart';
import '../material/tiles/AppUserTile.dart';
import 'ClassAdminPage.dart';

import '../static/server.dart' as server;
import '../static/serverUserMember.dart' as server;
import '../static/serverCourseAdmin.dart' as server;
import '../static/serverClassAdmin.dart' as server;
import '../static/serverTeamMember.dart' as server;

import '../json/session.dart';
import '../json/course.dart';
import '../json/slot.dart';
import '../json/user.dart';
import '../json/branch.dart';

class CourseAdminPage extends StatefulWidget {
  final Session session;
  final Course course;
  final bool isDraft;

  CourseAdminPage({Key? key, required this.session, required this.course, required this.isDraft}) : super(key: key);

  @override
  CourseAdminPageState createState() => CourseAdminPageState();
}

class CourseAdminPageState extends State<CourseAdminPage> {
  List<Slot> _slots = [];
  List<User> _moderatorPool = [];
  List<User> _moderatorList = [];

  List<Team> _teamsAvailable = [];
  List<Team> _teamsChosen = [];

  TextEditingController _ctrlCourseKey = TextEditingController();
  TextEditingController _ctrlCourseTitle = TextEditingController();
  bool _ctrlCourseActive = true;
  bool _ctrlCoursePublic = true;
  DropdownController<Branch> _ctrlCourseBranch = DropdownController<Branch>(items: server.cacheBranches);
  int _pickThresholdValue = 0;

  CourseAdminPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    if (!widget.isDraft) _getCourseSlots();
    if (!widget.isDraft) _getModeratorPool();
    if (!widget.isDraft) _getModeratorList();
    if (!widget.isDraft) _getTeamsAvailable();
    if (!widget.isDraft) _getTeamsChosen();

    _applyCourse();
  }

  void _deleteCourse() async {
    bool success = await server.course_delete(widget.session, widget.course.id);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete course')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted course')));
    Navigator.pop(context);
  }

  Future<void> _duplicateCourse() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseAdminPage(
          session: widget.session,
          course: Course.fromCourse(widget.course),
          isDraft: true,
        ),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _getCourseSlots() async {
    List<Slot> slots = await server.class_list(widget.session, widget.course.id);
    slots.sort();

    setState(() {
      _slots = slots;
    });
  }

  Future<void> _selectCourseSlot(Slot slot, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassAdminPage(
          session: widget.session,
          courseID: widget.course.id,
          slot: slot,
          isDraft: isDraft,
        ),
      ),
    );

    _getCourseSlots();
  }

  Future<void> _getModeratorPool() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    setState(() {
      _moderatorPool = users;
    });
  }

  Future<void> _getModeratorList() async {
    List<User> users = await server.course_moderator_list(widget.session, widget.course.id);
    users.sort();

    setState(() {
      _moderatorList = users;
    });
  }

  void _addModerator(User user) async {
    bool success = await server.course_moderator_add(widget.session, widget.course.id, user.id);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add moderator')));
      return;
    }

    _getModeratorList();
  }

  void _removeModerator(User user) async {
    bool success = await server.course_moderator_remove(widget.session, widget.course.id, user.id);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove moderator')));
      return;
    }

    _getModeratorList();
  }

  Future<void> _getTeamsAvailable() async {
    List<Team> teams = await server.team_list(widget.session);
    teams.sort();

    setState(() {
      _teamsAvailable = teams;
    });
  }

  Future<void> _getTeamsChosen() async {
    List<Team> teams = await server.course_teaminvite_list(widget.session, widget.course.id);
    teams.sort();

    setState(() {
      _teamsChosen = teams;
    });
  }

  void _addTeam(Team team) async {
    bool success = await server.course_teaminvite_add(widget.session, widget.course.id, team.id);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add team')));
      return;
    }

    _getTeamsChosen();
  }

  void _removeTeam(Team team) async {
    bool success = await server.course_teaminvite_remove(widget.session, widget.course.id, team.id);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove team')));
      return;
    }

    _getTeamsChosen();
  }

  void _applyCourse() {
    _ctrlCourseKey.text = widget.course.key;
    _ctrlCourseTitle.text = widget.course.title;
    _ctrlCourseActive = widget.course.active;
    _ctrlCoursePublic = widget.course.public;
    _ctrlCourseBranch.value = widget.course.branch;
    _pickThresholdValue = widget.course.threshold;
  }

  void _gatherCourse() {
    widget.course.key = _ctrlCourseKey.text;
    widget.course.title = _ctrlCourseTitle.text;
    widget.course.active = _ctrlCourseActive;
    widget.course.public = _ctrlCoursePublic;
    widget.course.branch = _ctrlCourseBranch.value;
    widget.course.threshold = _pickThresholdValue;
  }

  void _submitCourse() async {
    _gatherCourse();

    bool success;
    if (widget.isDraft)
      success = await server.course_create(widget.session, widget.course);
    else
      success = await server.course_edit(widget.session, widget.course.id, widget.course);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit course')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully edited course')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Course Details"),
      ),
      body: AppBody(
        children: <Widget>[
          if (widget.course.id != 0)
            Row(
              children: [
                Expanded(
                  child: AppCourseTile(
                    course: widget.course,
                  ),
                ),
                if (widget.session.right!.admin_courses)
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _duplicateCourse,
                  ),
                if (widget.session.right!.admin_courses)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteCourse,
                  ),
              ],
            ),
          PanelSwiper(panels: [
            if (!widget.isDraft) Panel("Slots", _buildSlotPanel()),
            if (!widget.isDraft)
              Panel(
                  "Moderators",
                  SelectionPanel<User>(
                    available: _moderatorPool,
                    chosen: _moderatorList,
                    onAdd: _addModerator,
                    onRemove: _removeModerator,
                    filter: filterUsers,
                    builder: (User user) => AppUserTile(user: user),
                  )),
            if (!widget.isDraft)
              Panel(
                  "Team Invites",
                  SelectionPanel<Team>(
                    available: _teamsAvailable,
                    chosen: _teamsChosen,
                    onAdd: _addTeam,
                    onRemove: _removeTeam,
                    filter: filterTeams,
                    builder: (Team team) => AppTeamTile(team: team),
                  )),
            if (widget.session.right!.admin_courses) Panel("Edit", buildEditPanel()),
          ]),
        ],
      ),
    );
  }

  Widget _buildSlotPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          leading: Icon(Icons.add),
          text: "New slot",
          onPressed: () => _selectCourseSlot(Slot.fromCourse(widget.course), true),
        ),
        AppListView<Slot>(
          items: _slots,
          itemBuilder: (Slot slot) {
            return AppSlotTile(
              onTap: (Slot _slot) => _selectCourseSlot(_slot, false),
              slot: slot,
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
            onChanged: (bool? active) => setState(() => _ctrlCourseActive = active!),
          ),
        ),
        AppInfoRow(
          info: Text("Public"),
          child: Checkbox(
            value: _ctrlCoursePublic,
            onChanged: (bool? public) => setState(() => _ctrlCoursePublic = public!),
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
            )),
        AppButton(
          text: "Save",
          onPressed: _submitCourse,
        ),
      ],
    );
  }
}
