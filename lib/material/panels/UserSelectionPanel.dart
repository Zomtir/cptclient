import 'package:flutter/material.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/dialogs/UserPicker.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/material/AppButton.dart';

import 'package:cptclient/json/user.dart';

class UserSelectionPanel extends StatelessWidget {
  final List<User> usersAvailable;
  final List<User> usersChosen;
  final Function(User) onAdd;
  final Function(User) onRemove;

  const UserSelectionPanel({
    Key? key,
    required this.usersAvailable,
    this.usersChosen = const [],
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(text: "Add", onPressed: () => showUserPicker(
          context: context,
          usersAvailable: usersAvailable,
          usersHidden: usersChosen,
          onSelect: onAdd,
        )),
        AppListView<User>(
          items: usersChosen,
          itemBuilder: (User user) {
            return Row(
              children: [
                Expanded(
                  child: AppUserTile(
                    item: user,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => onRemove(user),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

}
