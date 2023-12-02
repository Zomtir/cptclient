import 'package:flutter/material.dart';
import 'package:cptclient/material/RoundBox.dart';
import 'package:cptclient/json/term.dart';

import '../../static/format.dart';

class AppTermTile extends StatelessWidget {
  final Term term;

  const AppTermTile({
    Key? key,
    required this.term,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "${term.id}", child: Icon(Icons.info)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${term.user!.firstname} ${term.user!.lastname}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(niceDate(term.begin) + " - " + niceDate(term.end)),
            ],
          ),
        ],
      )
    );
  }

}
