import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/RoundBox.dart';
import 'package:cptclient/static/format.dart';
import 'package:flutter/material.dart';

class AppSlotTile extends StatelessWidget {
  final Slot slot;
  final List<Widget> trailing;

  const AppSlotTile({
    super.key,
    required this.slot,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(.0),
            child: Tooltip(message: "[${slot.id}] ${slot.key}", child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${slot.title}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${slot.location!.title}"),
                Text(compressDate(slot.begin, slot.end), style: TextStyle(color: Colors.black54)),
                Text(slot.status!.name, textScaler: TextScaler.linear(1.3), style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
