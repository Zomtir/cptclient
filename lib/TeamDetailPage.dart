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
  final void Function() onUpdate;

  TeamDetailPage({Key? key, required this.session, required this.team, required this.onUpdate}) : super(key: key);

  @override
  TeamDetailPageState createState() => TeamDetailPageState();
}

class TeamDetailPageState extends State<TeamDetailPage> {
  TextEditingController _ctrlName = TextEditingController();
  TextEditingController _ctrlDescription = TextEditingController();

  bool _ctrlRightCourse = false;
  bool _ctrlRightRanking = false;
  bool _ctrlRightReservation = false;
  bool _ctrlRightTeam = false;
  bool _ctrlRightUser = false;

  TeamDetailPageState();

  @override
  void initState() {
    super.initState();
    _applyTeam();
  }

  void _applyTeam() {
    _ctrlName.text = widget.team.name;
    _ctrlDescription.text = widget.team.description;
    _ctrlRightCourse = widget.team.right_course_edit;
    _ctrlRightRanking = widget.team.right_ranking_edit;
    _ctrlRightReservation = widget.team.right_reservation_edit;
    _ctrlRightTeam = widget.team.right_team_edit;
    _ctrlRightUser = widget.team.right_user_edit;
  }

  void _gatherTeam() {
    widget.team.name = _ctrlName.text;
    widget.team.description = _ctrlDescription.text;
    widget.team.right_course_edit = _ctrlRightCourse;
    widget.team.right_ranking_edit = _ctrlRightRanking;
    widget.team.right_reservation_edit = _ctrlRightReservation;
    widget.team.right_team_edit = _ctrlRightTeam;
    widget.team.right_user_edit = _ctrlRightUser;
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Succeeded to edit team')));
    widget.onUpdate();
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
    widget.onUpdate();
    Navigator.pop(context);
  }

  void _duplicateTeam() {
    Team _team = Team.fromTeam(widget.team);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeamDetailPage(session: widget.session, team: _team, onUpdate: widget.onUpdate)));
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
            info: Text("Course Edit"),
            child: Checkbox(
              value: _ctrlRightCourse,
              onChanged: (bool? enabled) =>  setState(() => _ctrlRightCourse = enabled!),
            ),
          ),
          AppInfoRow(
            info: Text("Reservation Edit"),
            child: Checkbox(
              value: _ctrlRightReservation,
              onChanged: (bool? enabled) =>  setState(() => _ctrlRightReservation = enabled!),
            ),
          ),
          AppInfoRow(
            info: Text("Ranking Edit"),
            child: Checkbox(
              value: _ctrlRightRanking,
              onChanged: (bool? enabled) =>  setState(() => _ctrlRightRanking = enabled!),
            ),
          ),
          AppInfoRow(
            info: Text("Team Edit"),
            child: Checkbox(
              value: _ctrlRightTeam,
              onChanged: (bool? enabled) =>  setState(() => _ctrlRightTeam = enabled!),
            ),
          ),
          AppInfoRow(
            info: Text("User Edit"),
            child: Checkbox(
              value: _ctrlRightUser,
              onChanged: (bool? enabled) =>  setState(() => _ctrlRightUser = enabled!),
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
