import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppInfoRow.dart';
import 'material/app/AppButton.dart';
import 'material/app/AppMemberTile.dart';

import 'static/serverUserAdmin.dart' as server;
import 'static/crypto.dart' as crypto;
import 'json/session.dart';
import 'json/user.dart';

class UserAdminPage extends StatefulWidget {
  final Session session;
  final User user;
  final void Function() onUpdate;
  final bool isDraft;

  UserAdminPage({Key? key, required this.session, required this.user, required this.onUpdate, required this.isDraft}) : super(key: key);

  @override
  UserAdminPageState createState() => UserAdminPageState();
}

class UserAdminPageState extends State<UserAdminPage> {
  TextEditingController _ctrlUserKey = TextEditingController();
  TextEditingController _ctrlUserPassword = TextEditingController();
  TextEditingController _ctrlUserFirstname = TextEditingController();
  TextEditingController _ctrlUserLastname = TextEditingController();
  TextEditingController _ctrlUserEmail = TextEditingController();
  TextEditingController _ctrlUserPhone = TextEditingController();
  TextEditingController _ctrlUserAddress = TextEditingController();
  TextEditingController _ctrlUserBirthday = TextEditingController();
  TextEditingController _ctrlUserGender = TextEditingController();

  UserAdminPageState();

  @override
  void initState() {
    super.initState();
    _applyUser();
  }

  void _applyUser() {
    _ctrlUserKey.text = widget.user.key;
    _ctrlUserFirstname.text = widget.user.firstname;
    _ctrlUserLastname.text = widget.user.lastname;
    _ctrlUserPassword.text = "";
  }

  void _gatherUser() {
    widget.user.key = _ctrlUserKey.text;
    widget.user.firstname = _ctrlUserFirstname.text;
    widget.user.lastname = _ctrlUserLastname.text;
    widget.user.pwd = crypto.hashPassword(_ctrlUserPassword.text, _ctrlUserKey.text);
  }

  void _submitUser() async {
    _gatherUser();

    bool success = widget.isDraft ? await server.user_create(widget.session, widget.user) : await server.user_edit(widget.session, widget.user);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit user')));
      return;
    }

    widget.onUpdate();
    Navigator.pop(context);
  }

  void _deleteUser() async {
    if (!await server.user_delete(widget.session, widget.user)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user')));
      return;
    }

    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft) Row(
            children: [
              Expanded(
                child: AppMemberTile(
                  onTap: (member) => {},
                  item: widget.user,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteUser,
              ),
            ],
          ),
          AppInfoRow(
            info: Text("Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserKey,
            ),
          ),
          AppInfoRow(
            info: Text("Password"),
            child: TextField(
              obscureText: true,
              maxLines: 1,
              controller: _ctrlUserPassword,
              decoration: InputDecoration(
                hintText: "Reset password (leave empty to keep current password)",
              ),
            ),
          ),
          AppInfoRow(
            info: Text("First Name"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserFirstname,
            ),
          ),
          AppInfoRow(
            info: Text("Last Name"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserLastname,
            ),
          ),
          AppInfoRow(
            info: Text("E-Mail"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserEmail,
            ),
          ),
          AppInfoRow(
            info: Text("Phone"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserPhone,
            ),
          ),
          AppInfoRow(
            info: Text("Address"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserAddress,
            ),
          ),
          AppInfoRow(
            info: Text("Birthday"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserBirthday,
            ),
          ),
          AppInfoRow(
            info: Text("Gender"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserGender,
            ),
          ),
          AppButton(
            text: "Save",
            onPressed: _submitUser,
          ),
        ],
      ),
    );
  }
}
