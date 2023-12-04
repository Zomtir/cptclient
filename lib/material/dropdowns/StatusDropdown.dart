import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/json/slot.dart';

import 'AppDropdown.dart';

class StatusDropdown extends StatelessWidget {
  final DropdownController<Status> controller;
  final void Function() onChanged;

  StatusDropdown({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppInfoRow(
      info: Text(AppLocalizations.of(context)!.slotStatus),
      child: AppDropdown<Status>(
        controller: controller,
        builder: (Status status) {
          return Text(status.name);
        },
        onChanged: (Status? status) {
          controller.value = status;
          onChanged();
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          controller.value = null;
          onChanged();
        },
      ),
    );
  }
}


