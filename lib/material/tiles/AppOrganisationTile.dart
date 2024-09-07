import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppOrganisationTile extends StatelessWidget {
  final Organisation organisation;
  final List<Widget> trailing;

  const AppOrganisationTile({
    super.key,
    required this.organisation,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message: "[${organisation.id}] ${organisation.abbreviation}",
              child: Icon(Icons.info),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${organisation.abbreviation}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${organisation.name}", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
