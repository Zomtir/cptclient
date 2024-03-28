import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompetenceDropdown extends StatelessWidget {
  final FieldController<Skill> controller;
  final RangeValues range;
  final void Function(Skill?, RangeValues) onChanged;

  CompetenceDropdown({
    super.key,
    required this.controller,
    required this.range,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppInfoRow(
          info: Text(AppLocalizations.of(context)!.courseRanking),
          child: AppField<Skill>(
            controller: controller,
            onChanged: (Skill? skill) => onChanged(skill, range),
          ),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => onChanged(null, range),
          ),
        ),
        if (controller.value != null) AppInfoRow(
          info: Text("Rank Range"),
          child: RangeSlider(
            values: range,
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (RangeValues values) => onChanged(controller.value, values),
            labels: RangeLabels("${range.start}", "${range.end}"),
          ),
        ),
      ],
    );
  }
}
