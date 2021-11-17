import 'package:flutter/material.dart';
import 'package:cptclient/material/app/AppTile.dart';
import 'package:cptclient/json/team.dart';

class AppTeamTile extends StatelessWidget {

  final Team item;
  final Function(Team) onTap;

  const AppTeamTile({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTile<Team>(
      onTap: onTap,
      item: item,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "${item.id}", child: Icon(Icons.info)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${item.name}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${item.description}"),
            ],
          ),
        ],
      )
    );
  }

}
