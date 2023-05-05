import 'package:flutter/material.dart';
import 'package:cptclient/json/skill.dart';

import '../RoundBox.dart';

class AppSkillTile extends StatelessWidget {
  final Skill skill;

  const AppSkillTile({
    Key? key,
    required this.skill,
  }) : super(key: key);

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
