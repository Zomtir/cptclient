import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/pages/UserAdminPage.dart';
import 'package:cptclient/static/server_user_admin.dart' as server;
import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserManagementPage extends StatefulWidget {
  final Session session;

  UserManagementPage({super.key, required this.session});

  @override
  UserManagementPageState createState() => UserManagementPageState();
}

class UserManagementPageState extends State<UserManagementPage> {
  late SelectionData<User> _userData;

  @override
  void initState() {
    super.initState();

    _userData = SelectionData<User>(
        available: [],
        selected: [],
        onSelect: _selectUser,
        onDeselect: (user)=>{},
        filter: filterUsers
    );

    _update();
  }

  Future<void> _update() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    _userData.available = users;
  }

  void _selectUser(User user) async {
    User? userdetailed = await server.user_detailed(widget.session, user);

    if (userdetailed == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAdminPage(
          session: widget.session,
          user: userdetailed,
          onUpdate: _update,
          isDraft: false,
        ),
      ),
    );
  }

  void _createUser() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAdminPage(
          session: widget.session,
          user: User.fromVoid(),
          onUpdate: _update,
          isDraft: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageUserManagement),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionNew,
            onPressed: _createUser,
          ),
          SearchablePanel<User>(
            dataModel: _userData,
            builder: (User user) => AppUserTile(user: user),
          ),
        ],
      ),
    );
  }
}
