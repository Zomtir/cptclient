import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/api/anon/club.dart' as api_anon;
import 'package:cptclient/api/regular/team/team.dart' as api_regular;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/pages/FilterPage.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/pages/ClassOverviewMangementPage.dart';
import 'package:cptclient/pages/CourseClubEditPage.dart';
import 'package:cptclient/pages/CourseEditPage.dart';
import 'package:cptclient/pages/CourseStatisticClassPage.dart';
import 'package:cptclient/pages/CourseStatisticPresencePage.dart';
import 'package:cptclient/pages/RequirementOverviewPage.dart';
import 'package:flutter/material.dart';

class CourseDetailManagementPage extends StatefulWidget {
  final UserSession session;
  final Course course;
  final bool isDraft;

  CourseDetailManagementPage({super.key, required this.session, required this.course, required this.isDraft});

  @override
  CourseDetailManagementPageState createState() => CourseDetailManagementPageState();
}

class CourseDetailManagementPageState extends State<CourseDetailManagementPage> {
  CourseDetailManagementPageState();

  @override
  void initState() {
    super.initState();
  }

  _handleEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseEditPage(
          session: widget.session,
          course: widget.course,
          isDraft: false,
          onSubmit: api_admin.course_edit,
        ),
      ),
    );
  }

  Future<void> _handleDuplicate() async {
    Course newCourse = Course.fromCourse(widget.course);
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseEditPage(
          session: widget.session,
          course: newCourse,
          isDraft: true,
          onSubmit: api_admin.course_create,
        ),
      ),
    );
  }

  _handleDelete() async {
    if (!await api_admin.course_delete(widget.session, widget.course)) return;

    Navigator.pop(context);
  }

  Future<void> _handleClasses() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassOverviewManagementPage(
          session: widget.session,
          course: widget.course,
          isDraft: false,
        ),
      ),
    );
  }

  Future<void> _handleClub() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseClubEditPage(
          session: widget.session,
          course: widget.course,
          callList: () => api_anon.club_list(),
          callInfo: () => api_admin.course_club_info(widget.session, widget.course),
          callEdit: (club) => api_admin.course_club_edit(widget.session, widget.course, club),
        ),
      ),
    );
  }

  Future<void> _handleModerators() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageCourseModerators,
          tile: widget.course.buildCard(context),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_admin.course_moderator_list(widget.session, widget.course.id),
          onCallAdd: (user) => api_admin.course_moderator_add(widget.session, widget.course.id, user.id),
          onCallRemove: (user) => api_admin.course_moderator_remove(widget.session, widget.course.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleRequirements() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequirementOverviewPage(session: widget.session, course: widget.course),
      ),
    );
  }

  Future<void> _handleAttendanceSieves(String role) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<Team>(
          title: AppLocalizations.of(context)!.pageCourseAttendanceSieves,
          tile: widget.course.buildCard(context),
          onCallAvailable: () => api_regular.team_list(widget.session),
          onCallSelected: () => api_admin.course_attendance_sieve_list(widget.session, widget.course.id, role),
          onCallEdit: (team, access) =>
              api_admin.course_attendance_sieve_edit(widget.session, widget.course.id, team.id, role, access),
          onCallRemove: (team) =>
              api_admin.course_attendance_sieve_remove(widget.session, widget.course.id, team.id, role),
        ),
      ),
    );
  }

  Future<void> _handleStatisticClass() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseStatisticClassPage(
          session: widget.session,
          course: widget.course,
        ),
      ),
    );
  }

  Future<void> _handleStatisticAttendance(String role) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseStatisticPresencePage(
          session: widget.session,
          course: widget.course,
          title: AppLocalizations.of(context)!.pageCourseStatisticAttendance,
          presence: () => api_admin.course_statistic_attendance(widget.session, widget.course.id, role),
          presence1: (int ownerID) =>
              api_admin.course_statistic_attendance1(widget.session, widget.course.id, ownerID, role),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _handleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _handleDuplicate,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          widget.course.buildCard(context),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseClasses),
                onTap: _handleClasses,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseRequirements),
                onTap: _handleRequirements,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseModerators),
                onTap: _handleModerators,
              ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.pageCourseAttendanceSieves,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.eventParticipant),
                onTap: () => _handleAttendanceSieves('PARTICIPANTS'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.eventLeader),
                onTap: () => _handleAttendanceSieves('LEADER'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.eventSupporter),
                onTap: () => _handleAttendanceSieves('SUPPORTER'),
              ),
            ],
          ),
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseClub),
                onTap: _handleClub,
              ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.pageCourseStatisticAttendance,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseStatisticClasses),
                onTap: _handleStatisticClass,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.eventParticipant),
                onTap: () => _handleStatisticAttendance('PARTICIPANT'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.eventLeader),
                onTap: () => _handleStatisticAttendance('LEADER'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.eventSupporter),
                onTap: () => _handleStatisticAttendance('SUPPORTER'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
