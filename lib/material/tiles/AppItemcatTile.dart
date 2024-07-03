import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppItemcatTile extends StatelessWidget {
  final ItemCategory category;
  final List<Widget> trailing;

  const AppItemcatTile({
    super.key,
    required this.category,
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
              message: "[${category.id}]",
              child: Icon(Icons.info),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${category.name}", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
