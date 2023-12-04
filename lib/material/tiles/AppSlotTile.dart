import 'package:flutter/material.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/RoundBox.dart';

class AppSlotTile extends StatelessWidget {
  final Slot slot;
  final List<Widget> trailing;

  const AppSlotTile({
    Key? key,
    required this.slot,
    this.trailing = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "[${slot.id}] ${slot.key}", child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${slot.title}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${slot.location!.title}"),
                Text(compressDate(slot.begin, slot.end), style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
