import 'package:cptclient/json/license.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppLicenseTile extends StatelessWidget {
  final License license;
  final List<Widget> trailing;

  const AppLicenseTile({
    super.key,
    required this.license,
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
              message: "[${license.id}]",
              child: Icon(Icons.info),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${license.name}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${license.number}"),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
