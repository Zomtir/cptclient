import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:flutter/material.dart';

class SkillRangeField extends StatelessWidget {
  final FieldController<Skill> controller;
  final RangeValues range;
  final void Function(Skill?, RangeValues) onChanged;

  SkillRangeField({
    super.key,
    required this.controller,
    required this.range,
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
              onChanged: (Skill? skill) => onChanged(skill, range),
            ),
            if (controller.value != null)
              RangeSlider(
                values: range,
                min: controller.value?.min.toDouble() ?? 0,
                max: controller.value?.max.toDouble() ?? 0,
                divisions: 10,
                onChanged: (RangeValues values) => onChanged(controller.value, values),
                labels: RangeLabels("${range.start}", "${range.end}"),
              ),
          ],
        ),
      ],
    );
  }
}
