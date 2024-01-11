import 'package:cptclient/json/ranking.dart';
import 'package:cptclient/static/format.dart';
import 'package:flutter/material.dart';

class AppRankingTile extends StatelessWidget {
  final Ranking ranking;

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
            Text("${ranking.branch!.key} ${ranking.rank}"),
            Text("${niceDateTime(ranking.date)} ${ranking.judge!.firstname} ${ranking.judge!.lastname}", style: TextStyle(color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}
