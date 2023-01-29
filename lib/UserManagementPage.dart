import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';

import 'UserAdminPage.dart';

import 'static/serverUserAdmin.dart' as server;
import 'json/session.dart';
import 'json/user.dart';

class UserManagementPage extends StatefulWidget {
  final Session session;

  UserManagementPage({Key? key, required this.session}) : super(key: key);

  @override
  UserManagementPageState createState() => UserManagementPageState();
}

class UserManagementPageState extends State<UserManagementPage> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _requestUsers();
  }

  Future<void> _requestUsers() async {
    List<User> users = await server.user_list(widget.session);
    setState(() {
      _users = users;
    });
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
        title: Text("User Administration"),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: "New user",
            onPressed: _createUser,
          ),
          AppListView<User>(
            items: _users,
            itemBuilder: (User user) {
              return AppUserTile(
                onTap: (u) => _selectUser(user),
                user: user,
              );
            },
          ),
        ],
      ),
    );
  }
}
