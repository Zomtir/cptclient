import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/ClassOverviewMangementPage.dart';
import 'package:cptclient/pages/CourseEditPage.dart';
import 'package:cptclient/pages/CourseStatisticClassPage.dart';
import 'package:cptclient/pages/CourseStatisticOwnerPage.dart';
import 'package:cptclient/pages/CourseStatisticParticipantPage.dart';
import 'package:cptclient/pages/RequirementOverviewPage.dart';
import 'package:cptclient/static/server_course_admin.dart' as api_admin;
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

  Future<void> _handleParticipantSummons() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<Team>(
          title: AppLocalizations.of(context)!.pageCourseParticipantSummons,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: () => api_regular.team_list(widget.session),
          onCallSelected: () => api_admin.course_participant_summon_list(widget.session, widget.course.id),
          onCallAdd: (team) => api_admin.course_participant_summon_add(widget.session, widget.course.id, team.id),
          onCallRemove: (team) => api_admin.course_participant_summon_remove(widget.session, widget.course.id, team.id),
        ),
      ),
    );
  }

  Future<void> _handleParticipantUnsummons() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<Team>(
          title: AppLocalizations.of(context)!.pageCourseParticipantUnsummons,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: () => api_regular.team_list(widget.session),
          onCallSelected: () => api_admin.course_participant_unsummon_list(widget.session, widget.course.id),
          onCallAdd: (team) => api_admin.course_participant_unsummon_add(widget.session, widget.course.id, team.id),
          onCallRemove: (team) => api_admin.course_participant_unsummon_remove(widget.session, widget.course.id, team.id),
        ),
      ),
    );
  }

  Future<void> _handleOwnerSummons() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<Team>(
          title: AppLocalizations.of(context)!.pageCourseOwnerSummons,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: () => api_regular.team_list(widget.session),
          onCallSelected: () => api_admin.course_owner_summon_list(widget.session, widget.course.id),
          onCallAdd: (team) => api_admin.course_owner_summon_add(widget.session, widget.course.id, team.id),
          onCallRemove: (team) => api_admin.course_owner_summon_remove(widget.session, widget.course.id, team.id),
        ),
      ),
    );
  }

  Future<void> _handleOwnerUnsummons() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<Team>(
          title: AppLocalizations.of(context)!.pageCourseOwnerUnsummons,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: () => api_regular.team_list(widget.session),
          onCallSelected: () => api_admin.course_owner_unsummon_list(widget.session, widget.course.id),
          onCallAdd: (team) => api_admin.course_owner_unsummon_add(widget.session, widget.course.id, team.id),
          onCallRemove: (team) => api_admin.course_owner_unsummon_remove(widget.session, widget.course.id, team.id),
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
            text: AppLocalizations.of(context)!.pageCourseRequirements,
            onPressed: _handleRequirements,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseModerators,
            onPressed: _handleModerators,
          ),
          Divider(),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseParticipantSummons,
            onPressed: _handleParticipantSummons,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseParticipantUnsummons,
            onPressed: _handleParticipantUnsummons,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseOwnerSummons,
            onPressed: _handleOwnerSummons,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseOwnerUnsummons,
            onPressed: _handleOwnerUnsummons,
          ),
          Divider(),
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
