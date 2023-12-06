import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';

import 'UserAdminPage.dart';

import '../static/serverUserAdmin.dart' as server;
import '../json/session.dart';
import '../json/user.dart';

class UserManagementPage extends StatefulWidget {
  final Session session;

  UserManagementPage({Key? key, required this.session}) : super(key: key);

  @override
  UserManagementPageState createState() => UserManagementPageState();
}

class UserManagementPageState extends State<UserManagementPage> {
  List<User> _users = [];
  GlobalKey<SearchablePanelState<User>> _panelKey = GlobalKey<SearchablePanelState<User>>();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    print("start");
    print(_users.length);
    List<User> users = await server.user_list(widget.session);
    users.sort();

    setState(() {
      _users = users;
      _panelKey.currentState?.setItems(_users);
    });

    print("husers");
    print(_users.length);
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
    return new Scaffold(
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
            key: _panelKey,
            items: [],
            onSelect: _selectUser,
            filter: filterUsers,
            builder: (User user) => AppUserTile(user: user),
          ),
        ],
      ),
    );
  }
}
