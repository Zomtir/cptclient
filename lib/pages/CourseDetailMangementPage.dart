import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/pages/TeamSelectionPage.dart';
import 'package:cptclient/material/pages/UserSelectionPage.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/pages/ClassOverviewMangementPage.dart';
import 'package:cptclient/pages/CourseEditPage.dart';
import 'package:cptclient/pages/CourseStatisticClassPage.dart';
import 'package:cptclient/static/server_course_admin.dart' as api_admin;
import 'package:cptclient/static/server_team_regular.dart' as api_regular;
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
        builder: (context) => UserSelectionPage(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageCourseModerators,
          tile: AppCourseTile(course: widget.course),
          onCallList: (session) => api_admin.course_moderator_list(session, widget.course.id),
          onCallAdd: (session, user) => api_admin.course_moderator_add(session, widget.course.id, user.id),
          onCallRemove: (session, user) => api_admin.course_moderator_remove(session, widget.course.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleTeaminvites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamSelectionPage(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageCourseTeaminvites,
          tile: AppCourseTile(course: widget.course),
          onCallAvailable: (session) => api_regular.team_list(session),
          onCallSelected: (session) => api_admin.course_teaminvite_list(session, widget.course.id),
          onCallAdd: (session, team) => api_admin.course_teaminvite_add(session, widget.course.id, team.id),
          onCallRemove: (session, team) => api_admin.course_teaminvite_remove(session, widget.course.id, team.id),
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
            text: AppLocalizations.of(context)!.pageCourseTeaminvites,
            onPressed: _handleTeaminvites,
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
            onPressed: null,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseStatisticOwners,
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
