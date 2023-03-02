import 'package:flutter/material.dart';
import 'package:cptclient/json/skill.dart';

import '../design/AppBoxDecoration.dart';

class AppSkillTile extends StatelessWidget {
  final Skill skill;

  const AppSkillTile({
    Key? key,
    required this.skill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: AppBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${skill.branch.title}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${skill.rank}", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
