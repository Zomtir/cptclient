import 'package:cptclient/json/location.dart';
import 'package:cptclient/material/RoundBox.dart';
import 'package:flutter/material.dart';

class AppLocationTile extends StatelessWidget {
  final Location location;
  final List<Widget> trailing;

  const AppLocationTile({
    super.key,
    required this.location,
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
                message: "[${location.id}] ${location.key}",
                child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${location.name}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${location.description}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
