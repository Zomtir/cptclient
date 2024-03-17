import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/pages/ClassOverviewMangementPage.dart';
import 'package:cptclient/pages/CourseEditPage.dart';
import 'package:cptclient/pages/CourseStatisticClassPage.dart';
import 'package:cptclient/pages/CourseStatisticOwnerPage.dart';
import 'package:cptclient/pages/CourseStatisticParticipantPage.dart';
import 'package:cptclient/static/server_course_admin.dart' as api_admin;
import 'package:cptclient/static/server_team_regular.dart' as api_regular;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseDetailManagementPage extends StatefulWidget {
  final Session session;
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
          session: widget.session,
          title: AppLocalizations.of(context)!.pageCourseModerators,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: (session) => api_regular.user_list(session),
          onCallSelected: (session) => api_admin.course_moderator_list(session, widget.course.id),
          onCallAdd: (session, user) => api_admin.course_moderator_add(session, widget.course.id, user.id),
          onCallRemove: (session, user) => api_admin.course_moderator_remove(session, widget.course.id, user.id),
          filter: filterUsers,
          builder: (User user) => AppUserTile(user: user),
        ),
      ),
    );
  }

  Future<void> _handleParticipantTeams() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<Team>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageCourseParticipantTeams,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: (session) => api_regular.team_list(session),
          onCallSelected: (session) => api_admin.course_participant_team_list(session, widget.course.id),
          onCallAdd: (session, team) => api_admin.course_participant_team_add(session, widget.course.id, team.id),
          onCallRemove: (session, team) => api_admin.course_participant_team_remove(session, widget.course.id, team.id),
          filter: filterTeams,
          builder: (team) => AppTeamTile(team: team),
        ),
      ),
    );
  }

  Future<void> _handleOwnerTeams() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<Team>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageCourseOwnerTeams,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: (session) => api_regular.team_list(session),
          onCallSelected: (session) => api_admin.course_owner_team_list(session, widget.course.id),
          onCallAdd: (session, team) => api_admin.course_owner_team_add(session, widget.course.id, team.id),
          onCallRemove: (session, team) => api_admin.course_owner_team_remove(session, widget.course.id, team.id),
          filter: filterTeams,
          builder: (team) => AppTeamTile(team: team),
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
        builder: (context) => CourseStatisticParticipantPage(
          session: widget.session,
          course: widget.course,
        ),
      ),
    );
  }

  Future<void> _handleStatisticOwner() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseStatisticOwnerPage(
          session: widget.session,
          course: widget.course,
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
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseClasses,
            onPressed: _handleClasses,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseParticipantTeams,
            onPressed: _handleParticipantTeams,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseOwnerTeams,
            onPressed: _handleOwnerTeams,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseModerators,
            onPressed: _handleModerators,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseRequirements,
            onPressed: null,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseStatisticClasses,
            onPressed: _handleStatisticClass,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseStatisticParticipants,
            onPressed: _handleStatisticParticipant,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseStatisticOwners,
            onPressed: _handleStatisticOwner,
          ),
        ],
      ),
    );
  }
}
