import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppUserTile extends StatelessWidget {
  final User user;
  final List<Widget> trailing;

  const AppUserTile({
    super.key,
    required this.user,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(message: "${user.id}", child: Icon(Icons.info)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${user.lastname}, ${user.firstname}", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${user.key}"),
                ],
              ),
            ),
            ...trailing,
          ],
        )
    );
  }

}
