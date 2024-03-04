import 'package:cptclient/json/club.dart';
import 'package:cptclient/material/RoundBox.dart';
import 'package:flutter/material.dart';

class AppClubTile extends StatelessWidget {
  final Club club;
  final List<Widget> trailing;

  const AppClubTile({
    super.key,
    required this.club,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "${club.id}", child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${club.name}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${club.description}"),
              ],
            ),
          ),
          ...trailing,
        ],
      )
    );
  }

}
