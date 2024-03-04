import 'package:cptclient/json/competence.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:flutter/material.dart';

class AppRankingTile extends StatelessWidget {
  final Competence ranking;

  const AppRankingTile({
    super.key,
    required this.ranking,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(message: "${ranking.id}", child: Icon(Icons.info)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${ranking.user!.firstname} ${ranking.user!.lastname}", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${ranking.skill!.key} ${ranking.rank}"),
            Text("${ranking.date.fmtDate(context)} ${ranking.judge!.firstname} ${ranking.judge!.lastname}", style: TextStyle(color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}
