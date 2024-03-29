import 'package:cptclient/json/competence.dart';
import 'package:cptclient/material/RoundBox.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:flutter/material.dart';

class AppCompetenceTile extends StatelessWidget {
  final Competence competence;

  const AppCompetenceTile({
    super.key,
    required this.competence,
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "${competence.id}", child: Icon(Icons.info)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${competence.user!.firstname} ${competence.user!.lastname}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${competence.skill!.key} ${competence.rank}"),
              Text("${competence.date.fmtDate(context)} ${competence.judge!.firstname} ${competence.judge!.lastname}", style: TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
