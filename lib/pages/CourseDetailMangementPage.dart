import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/MenuSection.dart';
import 'package:cptclient/material/pages/FilterPage.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/ClassOverviewMangementPage.dart';
import 'package:cptclient/pages/CourseEditPage.dart';
import 'package:cptclient/pages/CourseStatisticClassPage.dart';
import 'package:cptclient/pages/CourseStatisticPresencePage.dart';
import 'package:cptclient/pages/RequirementOverviewPage.dart';
import 'package:cptclient/static/server_team_regular.dart' as api_regular;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    if(!await api_admin.course_delete(widget.session, widget.course)) return;

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

  Future<void> _handleModerators() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageCourseModerators,
          tile: AppCourseTile(course: widget.course),
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

  Future<void> _handleParticipantSieves() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<Team>(
          title: AppLocalizations.of(context)!.pageCourseParticipantSieves,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: () => api_regular.team_list(widget.session),
          onCallSelected: () => api_admin.course_participant_sieve_list(widget.session, widget.course.id),
          onCallEdit: (team, access) => api_admin.course_participant_sieve_edit(widget.session, widget.course.id, team.id, access),
          onCallRemove: (team) => api_admin.course_participant_sieve_remove(widget.session, widget.course.id, team.id),
        ),
      ),
    );
  }

  Future<void> _handleLeaderSieves() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<Team>(
          title: AppLocalizations.of(context)!.pageCourseLeaderSieves,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: () => api_regular.team_list(widget.session),
          onCallSelected: () => api_admin.course_leader_sieve_list(widget.session, widget.course.id),
          onCallEdit: (team, access) => api_admin.course_leader_sieve_edit(widget.session, widget.course.id, team.id, access),
          onCallRemove: (team) => api_admin.course_leader_sieve_remove(widget.session, widget.course.id, team.id),
        ),
      ),
    );
  }

  Future<void> _handleSupporterSieves() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<Team>(
          title: AppLocalizations.of(context)!.pageCourseSupporterSieves,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: () => api_regular.team_list(widget.session),
          onCallSelected: () => api_admin.course_supporter_sieve_list(widget.session, widget.course.id),
          onCallEdit: (team, access) => api_admin.course_supporter_sieve_edit(widget.session, widget.course.id, team.id, access),
          onCallRemove: (team) => api_admin.course_supporter_sieve_remove(widget.session, widget.course.id, team.id),
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

  Future<void> _handleStatisticParticipant() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseStatisticPresencePage(
          session: widget.session,
          course: widget.course,
          title: AppLocalizations.of(context)!.pageCourseStatisticParticipants,
          presence: () => api_admin.course_statistic_participant(widget.session, widget.course.id),
          presence1: (int ownerID) => api_admin.course_statistic_participant1(widget.session, widget.course.id, ownerID),
        ),
      ),
    );
  }

  Future<void> _handleStatisticLeader() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseStatisticPresencePage(
          session: widget.session,
          course: widget.course,
          title: AppLocalizations.of(context)!.pageCourseStatisticLeaders,
          presence: () => api_admin.course_statistic_leader(widget.session, widget.course.id),
          presence1: (int ownerID) => api_admin.course_statistic_leader1(widget.session, widget.course.id, ownerID),
        ),
      ),
    );
  }

  Future<void> _handleStatisticSupporter() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseStatisticPresencePage(
          session: widget.session,
          course: widget.course,
          title: AppLocalizations.of(context)!.pageCourseStatisticSupporters,
          presence: () => api_admin.course_statistic_supporter(widget.session, widget.course.id),
          presence1: (int ownerID) => api_admin.course_statistic_supporter1(widget.session, widget.course.id, ownerID),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseDetails),
      ),
      body: AppBody(
        children: <Widget>[
          AppCourseTile(
            course: widget.course,
            trailing: [
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
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseParticipantSieves),
                onTap: _handleParticipantSieves,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseLeaderSieves),
                onTap: _handleLeaderSieves,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseSupporterSieves),
                onTap: _handleSupporterSieves,
              ),
            ],
          ),
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseStatisticClasses),
                onTap: _handleStatisticClass,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseStatisticParticipants),
                onTap: _handleStatisticParticipant,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseStatisticLeaders),
                onTap: _handleStatisticLeader,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseStatisticSupporters),
                onTap: _handleStatisticSupporter,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
