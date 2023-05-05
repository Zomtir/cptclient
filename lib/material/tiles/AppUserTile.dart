import 'package:flutter/material.dart';
import 'package:cptclient/json/user.dart';

import '../RoundBox.dart';

class AppUserTile extends StatelessWidget {
  final User user;

  const AppUserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundBox(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(message: "${user.id}", child: Icon(Icons.info)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${user.lastname}, ${user.firstname}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${user.key}"),
              ],
            ),
          ],
        )
    );
  }

}
