import 'package:cptclient/json/requirement.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppRequirementTile extends StatelessWidget {
  final Requirement requirement;
  final List<Widget> trailing;

  const AppRequirementTile({
    super.key,
    required this.requirement,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "${requirement.id}", child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${requirement.course!.title}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${requirement.skill!.title} ${requirement.rank}"),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
