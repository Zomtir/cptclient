import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/RoundBox.dart';
import 'package:flutter/material.dart';

class AppSkillTile extends StatelessWidget {
  final Skill skill;

  const AppSkillTile({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${skill.branch.title}", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("${skill.rank}", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
