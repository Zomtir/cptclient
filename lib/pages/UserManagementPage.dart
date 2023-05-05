import 'package:cptclient/material/TextFilter.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
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
  List<User> _usersLimited = [];
  TextEditingController _ctrlFilterUser = TextEditingController();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    _users = await server.user_list(widget.session);
    _ctrlFilterUser.clear();
    _limitUsers(_users);
  }

  void _limitUsers(List<User> users) {
    users.sort();
    setState(() {
      _usersLimited = users;
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
          TextFilter(
            items: _users,
            controller: _ctrlFilterUser,
            onChange: _limitUsers,
            filter: filterUsers,
          ),
          AppListView<User>(
            items: _usersLimited,
            itemBuilder: (User user) {
              return InkWell(
                onTap: () => _selectUser(user),
                child: AppUserTile(
                  user: user,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
