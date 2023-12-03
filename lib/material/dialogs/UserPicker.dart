import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppDialog.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/TextFilter.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';

import '../AppButton.dart';

Future<User?> showAppUserPicker({
  required BuildContext context,
  required users,
  User? initialUser,
}) async {
  Widget picker = UserPicker(
    users: users,
    initialUser: initialUser,
  );

  return showDialog<User>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppDialog(
        child: picker,
        maxWidth: 470,
      );
    },
  );
}

class UserPicker extends StatefulWidget {
  UserPicker({
    super.key,
    required this.users,
    required this.initialUser,
  });

  final List<User> users;
  final User? initialUser;

  @override
  State<UserPicker> createState() => _UserPickerState();
}

class _UserPickerState extends State<UserPicker> {
  List<User> _usersLimited = [];
  TextEditingController _ctrlFilterUser = TextEditingController();

  @override
  void initState() {
    super.initState();
    _limitUsers(widget.users);
  }

  void _handleConfirm(User user) {
    if (user == widget.initialUser)
      _handleCancel();
    else
      Navigator.pop(context, user);
  }

  void _handleCancel() {
    Navigator.pop(context, widget.initialUser);
  }

  void _limitUsers(List<User> users) {
    users.sort();
    setState(() {
      _usersLimited = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFilter(
          items: widget.users,
          controller: _ctrlFilterUser,
          onChange: _limitUsers,
          filter: filterUsers,
        ),
        AppListView<User>(
          items: _usersLimited,
          itemBuilder: (User user) {
            return InkWell(
              onTap: () => _handleConfirm(user),
              child: AppUserTile(
                user: user,
              ),
            );
          },
        ),
        Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              AppButton(
                onPressed: _handleCancel,
                text: AppLocalizations.of(context)!.actionCancel,
              ),
            ],
          ),
        )
      ],
    );
  }
}