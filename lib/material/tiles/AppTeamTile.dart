import 'package:cptclient/json/team.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppTeamTile extends StatelessWidget {
  final Team team;
  final List<Widget> trailing;

  const AppTeamTile({
    super.key,
    required this.team,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "[${team.id}] ${team.key}", child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${team.name}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${team.description}"),
              ],
            ),
          ),
          ...trailing,
        ],
      )
    );
  }

}
