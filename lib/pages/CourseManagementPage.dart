import 'package:cptclient/json/branch.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/FilterToggle.dart';
import 'package:cptclient/material/Tribox.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/dropdowns/RankingDropdown.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/CourseDetailMangementPage.dart';
import 'package:cptclient/pages/CourseEditPage.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_course_admin.dart' as server;
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final DropdownController<Branch> _ctrlRankingBranch = DropdownController<Branch>(items: server.cacheBranches);
  RangeValues _ctrlRankingRange = RangeValues(0, 10);

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

  Future<void> _selectCourse(Course course) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailManagementPage(session: widget.session, course: course, isDraft: false),
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
    Course newCourse = Course.fromCourse(course);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseEditPage(
          session: widget.session,
          course: newCourse,
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
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _createCourse,
          ),
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.courseModerator),
                child: AppDropdown<User>(
                  controller: _ctrlModerator,
                  builder: (User user) {
                    return Text(user.key);
                  },
                  onChanged: (User? user) => setState(() => _ctrlModerator.value = user),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => setState(() => _ctrlModerator.value = null),
                ),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.courseActive),
                child: Tribox(
                  value: _ctrlActive,
                  onChanged: (bool? active) => setState(() => _ctrlActive = active),
                ),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.coursePublic),
                child: Tribox(
                  value: _ctrlPublic,
                  onChanged: (bool? public) => setState(() => _ctrlPublic = public),
                ),
              ),
              RankingDropdown(
                controller: _ctrlRankingBranch,
                range: _ctrlRankingRange,
                onChanged: (Branch? branch, RangeValues range) => setState(() {
                  _ctrlRankingBranch.value = branch;
                  _ctrlRankingRange = range;
                }),
              ),
            ],
          ),
          AppListView<Course>(
            items: _courses,
            itemBuilder: (Course course) {
              return InkWell(
                onTap: () => _selectCourse(course),
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
