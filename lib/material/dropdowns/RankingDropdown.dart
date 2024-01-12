import 'package:cptclient/json/branch.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RankingDropdown extends StatelessWidget {
  final DropdownController<Branch> controller;
  final RangeValues range;
  final void Function(Branch?, RangeValues) onChanged;

  RankingDropdown({
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
          child: AppDropdown<Branch>(
            controller: controller,
            builder: (Branch branch) {
              return Text(branch.title);
            },
            onChanged: (Branch? branch) => onChanged(branch, range),
          ),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => onChanged(null, range),
          ),
        ),
        if (controller.value != null) AppInfoRow(
          info: Text("Ranking Range"),
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
