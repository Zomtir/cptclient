import 'package:cptclient/static/format.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/json/slot.dart';

class AppSlotTile extends StatelessWidget {
  final Slot slot;
  final Function(Slot)? onTap;

  const AppSlotTile({
    Key? key,
    required this.slot,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (onTap != null) ? () => onTap!(this.slot) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white60,
          border: Border.all(
            color: Colors.amber,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(message: "[${slot.id}] ${slot.key}", child: Icon(Icons.info)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${slot.title}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${slot.location!.title}"),
                Text(compressDate(slot.begin, slot.end), style: TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
