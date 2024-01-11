import 'package:cptclient/json/location.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationDropdown extends StatelessWidget {
  final DropdownController<Location> controller;
  final void Function()? onChanged;

  LocationDropdown({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppInfoRow(
      info: Text(AppLocalizations.of(context)!.slotLocation),
      child: AppDropdown<Location>(
        controller: controller,
        builder: (Location location) {
          return Text(location.key);
        },
        onChanged: (Location? location) {
          controller.value = location;
          onChanged?.call();
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          controller.value = null;
          onChanged?.call();
        },
      ),
    );
  }
}


