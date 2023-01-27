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

  UserManagementPageState();

  @override
  void initState() {
    super.initState();
    _requestUsers();
  }

  Future<void> _requestUsers() async {
    List<User> users = await server.user_list(widget.session);
    setState(() {
      _users = users;
    });
  }

  void _selectUser(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAdminPage(
          session: widget.session,
          user: user,
          onUpdate: _requestUsers,
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
          onUpdate: _requestUsers,
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
          AppListView(
            items: _users,
            itemBuilder: (User user) {
              return AppUserTile(
                onTap: (member) => _selectUser(_users.firstWhere((user) => user.id == member.id)),
                item: user,
              );
            },
          ),
        ],
      ),
    );
  }
}
