import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppInfoRow.dart';
import 'material/app/AppButton.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'material/app/AppTeamTile.dart';
import 'static/navigation.dart' as navi;
import 'json/session.dart';
import 'json/team.dart';

class TeamDetailPage extends StatefulWidget {
  final Session session;
  final Team team;

  TeamDetailPage({Key? key, required this.session, required this.team}) : super(key: key);

  @override
  TeamDetailPageState createState() => TeamDetailPageState();
}

class TeamDetailPageState extends State<TeamDetailPage> {
  TextEditingController _ctrlName = TextEditingController();
  TextEditingController _ctrlDescription = TextEditingController();
  bool _ctrlRightUser = false;
  bool _ctrlRightRanking = false;
  bool _ctrlRightReservation = false;
  bool _ctrlRightCourse = false;

  TeamDetailPageState();

  @override
  void initState() {
    super.initState();
    _applyTeam();
  }

  void _applyTeam() {
    _ctrlName.text = widget.team.name;
    _ctrlDescription.text = widget.team.description;
    _ctrlRightUser = widget.team.right_user_edit;
    _ctrlRightRanking = widget.team.right_ranking_edit;
    _ctrlRightRanking = widget.team.right_reservation_edit;
    _ctrlRightCourse = widget.team.right_course_edit;
  }

  void _gatherTeam() {
    widget.team.name = _ctrlName.text;
    widget.team.description = _ctrlDescription.text;
    widget.team.right_user_edit = _ctrlRightUser;
    widget.team.right_ranking_edit = _ctrlRightRanking;
    widget.team.right_reservation_edit = _ctrlRightRanking;
    widget.team.right_course_edit = _ctrlRightCourse;
  }

  void _submitTeam() async {
    _gatherTeam();

    final response = await http.post(
      Uri.http(navi.server, widget.team.id == 0 ? 'team_create' : 'team_edit'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Token': widget.session.token,
      },
      body: json.encode(widget.team),
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit team')));
      return;
    }

    Navigator.pop(context);
  }

  void _deleteTeam() async {
    final response = await http.head(
      Uri.http(navi.server, 'team_delete', {'team_id': widget.team.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete team')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted team')));
    Navigator.pop(context);
  }

  void _duplicateTeam() {
    Team _team = Team.fromTeam(widget.team);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeamDetailPage(session: widget.session, team: _team)));
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Team Details"),
      ),
      body: AppBody(
        children: [
          if (widget.team.id != 0) Row(
            children: [
              Expanded(
                child: AppTeamTile(
                  onTap: (team) => {},
                  item: widget.team,
                ),
              ),
              if (widget.session.user!.admin_courses) IconButton(
                icon: const Icon(Icons.copy),
                onPressed: _duplicateTeam,
              ),
              if (widget.session.user!.admin_courses) IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteTeam,
              ),
            ],
          ),
          AppInfoRow(
            info: Text("Name"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
            ),
          ),
          AppInfoRow(
            info: Text("Description"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlDescription,
            ),
          ),
          AppInfoRow(
            info: Text("Allow User Edit"),
            child: Checkbox(
              value: _ctrlRightUser,
              onChanged: (bool? enabled) =>  setState(() => _ctrlRightUser = enabled!),
            ),
          ),
          AppInfoRow(
            info: Text("Allow Reservation Edit"),
            child: Checkbox(
              value: _ctrlRightReservation,
              onChanged: (bool? enabled) =>  setState(() => _ctrlRightReservation = enabled!),
            ),
          ),
          AppInfoRow(
            info: Text("Allow Ranking Edit"),
            child: Checkbox(
              value: _ctrlRightRanking,
              onChanged: (bool? enabled) =>  setState(() => _ctrlRightRanking = enabled!),
            ),
          ),
          AppInfoRow(
            info: Text("Allow Course Edit"),
            child: Checkbox(
              value: _ctrlRightCourse,
              onChanged: (bool? enabled) =>  setState(() => _ctrlRightCourse = enabled!),
            ),
          ),
          AppButton(
            text: "Save",
            onPressed: _submitTeam,
          ),
        ],
      ),
    );
  }
}
