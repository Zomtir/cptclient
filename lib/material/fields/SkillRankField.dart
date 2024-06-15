import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:flutter/material.dart';

class SkillRankField extends StatelessWidget {
  final FieldController<Skill> controller;
  final int rank;
  final void Function(Skill?, int) onChanged;

  SkillRankField({
    super.key,
    required this.controller,
    required this.rank,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            AppField<Skill>(
              controller: controller,
              onChanged: (Skill? skill) => onChanged(skill, rank),
            ),
            if (controller.value != null)
             Slider(
                value: rank.toDouble(),
                min: controller.value?.min.toDouble() ?? 0,
                max: controller.value?.max.toDouble() ?? 0,
                divisions: (){
                  int div = (controller.value?.max ?? 0) - (controller.value?.min ?? 0);
                  div = div < 1 ? 1 : div;
                  return div;
                }.call(),
                onChanged: (double value) => onChanged(controller.value, value.toInt()),
                label: "$rank",
              ),
          ],
        ),
      ],
    );
  }
}
