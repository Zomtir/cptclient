import 'package:cptclient/json/event.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:cptclient/static/format.dart';
import 'package:flutter/material.dart';

class AppEventTile extends StatelessWidget {
  final Event event;
  final List<Widget> trailing;

  const AppEventTile({
    super.key,
    required this.event,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(.0),
            child: Tooltip(message: "[${event.id}] ${event.key}", child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${event.title}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(compressDate(context, event.begin, event.end)),
                Text("${event.location!.name}", style: TextStyle(color: Colors.black54)),
                Text("${event.occurrence!.localizedName(context)}", textScaler: TextScaler.linear(1.3), style: TextStyle(color: Colors.black54)),
                Text("${event.acceptance!.localizedName(context)}", textScaler: TextScaler.linear(1.3), style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
