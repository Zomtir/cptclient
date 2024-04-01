import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/RoundBox.dart';
import 'package:flutter/material.dart';

class AppSkillTile extends StatelessWidget {
  final Skill skill;
  final List<Widget> trailing;

  const AppSkillTile({
    super.key,
    required this.skill,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "[${skill.id}] ${skill.key}", child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${skill.title}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${skill.min} - ${skill.max}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
