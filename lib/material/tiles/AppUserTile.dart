import 'package:flutter/material.dart';
import 'package:cptclient/json/user.dart';

import 'AppTile.dart';

class AppUserTile extends StatelessWidget {
  final User item;
  final Function(User)? onTap;

  const AppUserTile({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTile<User>(
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
