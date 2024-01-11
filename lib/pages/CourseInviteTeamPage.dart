import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/panels/SelectionPanel.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:cptclient/static/server_course_admin.dart' as api_admin;
import 'package:cptclient/static/server_team_regular.dart' as api_regular;
import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter/material.dart';

class CourseInviteTeamPage extends StatefulWidget {
  final Session session;
  final Course course;
  final Future<bool> Function(Session, Course, Team) onAddTeam;
  final Future<bool> Function(Session, Course, Team) onRemoveTeam;

  CourseInviteTeamPage({super.key, required this.session, required this.course, required this.onAddTeam, required this.onRemoveTeam});

  @override
  CourseInviteTeamPageState createState() => CourseInviteTeamPageState();
}

class CourseInviteTeamPageState extends State<CourseInviteTeamPage> {
  late SelectionData<Team> _teamData;

  CourseInviteTeamPageState();

  @override
  void initState() {
    super.initState();

    _teamData = SelectionData<Team>(available: [], selected: [], onSelect: _addTeam, onDeselect: _removeTeam, filter: filterTeams);

    _update();
  }

  void _update() async {
    List<Team> teamsAvailable = await api_regular.team_list(widget.session);
    teamsAvailable.sort();

    List<Team> teamsSelected = await api_admin.course_teaminvite_list(widget.session, widget.course.id);
    teamsSelected.sort();

    _teamData.available = teamsAvailable;
    _teamData.selected = teamsSelected;
    _teamData.notifyListeners();
  }

  void _addTeam(Team team) async {
    if (!await api_admin.course_teaminvite_add(widget.session, widget.course.id, team.id)) return;
    _update();
  }

  void _removeTeam(Team team) async {
    if (!await api_admin.course_teaminvite_remove(widget.session, widget.course.id, team.id)) return;
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Team Invites"),
      ),
      body: AppBody(
        children: <Widget>[
          AppCourseTile(
            course: widget.course,
          ),
          SelectionPanel<Team>(
            dataModel: _teamData,
            builder: (Team team) => AppTeamTile(team: team),
          ),
        ],
      ),
    );
  }
}
