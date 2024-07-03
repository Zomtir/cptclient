import 'package:cptclient/json/item.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppItemTile extends StatelessWidget {
  final Item item;
  final List<Widget> trailing;

  const AppItemTile({
    super.key,
    required this.item,
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
              message: "[${item.id}]",
              child: Icon(Icons.info),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${item.name}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${item.category?.name ?? AppLocalizations.of(context)!.undefined}"),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
