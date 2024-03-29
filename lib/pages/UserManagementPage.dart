import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/AppSearchField.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/pages/UserAdminPage.dart';
import 'package:cptclient/static/server_user_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserManagementPage extends StatefulWidget {
  final Session session;

  UserManagementPage({super.key, required this.session});

  @override
  UserManagementPageState createState() => UserManagementPageState();
}

class UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController controller = TextEditingController();
  List<User> _users = [];
  List<User> _visible = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    _users = await api_admin.user_list(widget.session);
    _users.sort();
    _filter();
  }

  Future<void> _filter() async {
    setState(() => _visible = filterUsers(_users, controller.text));
  }

  void _selectUser(User user) async {
    User? userdetailed = await api_admin.user_detailed(widget.session, user);

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
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _createUser,
          ),
          AppSearchField(
            controller: controller,
            onChange: _filter,
          ),
          AppListView<User>(
            items: _visible,
            itemBuilder: (User user) {
              return InkWell(
                onTap: () => _selectUser(user),
                child: AppUserTile(user: user),
              );
            },
          ),
        ],
      ),
    );
  }
}
