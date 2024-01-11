import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppDialog.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late SelectionData<User> _userData;

  @override
  void initState() {
    super.initState();

    _userData = SelectionData<User>(
        available: widget.users,
        selected: [],
        onSelect: _handleConfirm,
        onDeselect: (user)=>{},
        filter: filterUsers
    );
  }

  List<User> _handleConfirm(User user) {
    if (user == widget.initialUser) {
      _handleCancel();
    } else {
      Navigator.pop(context, user);
    }

    return widget.users;
  }

  void _handleCancel() {
    Navigator.pop(context, widget.initialUser);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchablePanel<User>(
          dataModel: _userData,
          builder: (User user) => AppUserTile(user: user),
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
