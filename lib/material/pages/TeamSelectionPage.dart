import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/team.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/panels/SelectionPanel.dart';
import 'package:cptclient/material/tiles/AppTeamTile.dart';
import 'package:flutter/material.dart';

class TeamSelectionPage extends StatefulWidget {
  final Session session;
  final String title;
  final Widget tile;
  final Future<List<Team>> Function(Session) onCallAvailable;
  final Future<List<Team>> Function(Session) onCallSelected;
  final Future<bool> Function(Session, Team) onCallAdd;
  final Future<bool> Function(Session, Team) onCallRemove;

  TeamSelectionPage({
    super.key,
    required this.session,
    required this.title,
    required this.tile,
    required this.onCallAvailable,
    required this.onCallSelected,
    required this.onCallAdd,
    required this.onCallRemove,
  });

  @override
  TeamSelectionPageState createState() => TeamSelectionPageState();
}

class TeamSelectionPageState extends State<TeamSelectionPage> {
  List<Team> _available = [];
  List<Team> _selected = [];

  TeamSelectionPageState();

  @override
  void initState() {
    super.initState();

    _update();
  }

  void _update() async {
    List<Team> available = await widget.onCallAvailable(widget.session);
    available.sort();

    List<Team> selected = await widget.onCallSelected(widget.session);
    selected.sort();

    setState(() {
      _available = available;
      _selected = selected;
    });
  }

  void _add(Team team) async {
    if (!await widget.onCallAdd(widget.session, team)) return;
    _update();
  }

  void _remove(Team team) async {
    if (!await widget.onCallRemove(widget.session, team)) return;
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AppBody(
        children: [
          widget.tile,
          SelectionPanel<Team>(
            available: _available,
            selected: _selected,
            onSelect: _add,
            onDeselect: _remove,
            filter: filterTeams,
            builder: (Team team) => AppTeamTile(team: team),
          ),
        ],
      ),
    );
  }
}
