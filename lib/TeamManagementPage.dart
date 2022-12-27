import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppButton.dart';
import 'material/app/AppListView.dart';
import 'material/app/AppTeamTile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'TeamAdminPage.dart';

import 'static/navigation.dart' as navi;
import 'json/session.dart';
import 'json/team.dart';

class TeamManagementPage extends StatefulWidget {
  final Session session;

  TeamManagementPage({Key? key, required this.session}) : super(key: key);

  @override
  TeamManagementPageState createState() => TeamManagementPageState();
}

class TeamManagementPageState extends State<TeamManagementPage> {
  List <Team> _teams = [];

  TeamManagementPageState();

  @override
  void initState() {
    super.initState();
    _getTeams();
  }

  Future<void> _getTeams() async {
    final response = await http.get(
      Uri.http(navi.serverURL, '/admin/team_list'),
      headers: {
        'Token': widget.session.token,
        'Accept': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode != 200) return;

    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      _teams = List<Team>.from(l.map((model) => Team.fromJson(model)));
    });
  }

  void _selectTeam(Team team) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TeamAdminPage(session: widget.session, team: team, onUpdate: _getTeams)));
  }

  void _createTeam() async {
    _selectTeam(Team.fromVoid());
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Team Overview"),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: "New team",
            onPressed: _createTeam,
          ),
          AppListView(
            items: _teams,
            itemBuilder: (Team team) {
              return AppTeamTile(
                onTap: _selectTeam,
                item: team,
              );
            },
          ),
        ],
      ),
    );
  }

}
