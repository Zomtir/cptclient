import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppButton.dart';
import 'material/app/AppListView.dart';
import 'material/app/AppTeamTile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'TeamDetailPage.dart';

import 'static/navigation.dart' as navi;
import 'json/session.dart';
import 'json/team.dart';

class TeamOverviewPage extends StatefulWidget {
  final Session session;

  TeamOverviewPage({Key? key, required this.session}) : super(key: key);

  @override
  TeamOverviewPageState createState() => TeamOverviewPageState();
}

class TeamOverviewPageState extends State<TeamOverviewPage> {
  List <Team> _teams = [];

  TeamOverviewPageState();

  Future<void> _getTeams() async {
    final response = await http.get(
      Uri.http(navi.server, 'team_list'),
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => TeamDetailPage(session: widget.session, team: team, onUpdate: _getTeams)));
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
