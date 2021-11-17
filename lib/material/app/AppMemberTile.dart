import 'package:flutter/material.dart';
import 'package:cptclient/json/member.dart';

import 'AppTile.dart';

class AppMemberTile extends StatelessWidget {
  final Member item;
  final Function(Member) onTap;

  const AppMemberTile({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTile<Member>(
        onTap: onTap,
        item: item,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(message: "${item.id}", child: Icon(Icons.info)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${item.lastname}, ${item.firstname}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${item.key}"),
              ],
            ),
          ],
        )
    );
  }

}
