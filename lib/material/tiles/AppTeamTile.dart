import 'package:flutter/material.dart';
import 'package:cptclient/material/RoundBox.dart';
import 'package:cptclient/json/team.dart';

class AppTeamTile extends StatelessWidget {
  final Team team;

  const AppTeamTile({
    Key? key,
    required this.team,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "${team.id}", child: Icon(Icons.info)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${team.name}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${team.description}"),
            ],
          ),
        ],
      )
    );
  }

}
