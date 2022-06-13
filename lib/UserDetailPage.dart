import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppInfoRow.dart';
import 'material/app/AppButton.dart';
import 'material/app/AppMemberTile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'static/navigation.dart' as navi;
import 'static/crypto.dart' as crypto;
import 'json/session.dart';
import 'json/user.dart';
import 'json/member.dart';

class UserDetailPage extends StatefulWidget {
  final Session session;
  final User user;
  final void Function() onUpdate;

  UserDetailPage({Key? key, required this.session, required this.user, required this.onUpdate}) : super(key: key);

  @override
  UserDetailPageState createState() => UserDetailPageState();
}

class UserDetailPageState extends State<UserDetailPage> {
  TextEditingController _ctrlUserKey = TextEditingController();
  TextEditingController _ctrlUserPassword = TextEditingController();
  TextEditingController _ctrlUserFirstname = TextEditingController();
  TextEditingController _ctrlUserLastname = TextEditingController();
  TextEditingController _ctrlUserEmail = TextEditingController();
  TextEditingController _ctrlUserTerm = TextEditingController();

  UserDetailPageState();

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

    final response = await http.post(
      Uri.http(navi.server, widget.user.id == 0 ? 'user_create' : 'user_edit'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Token': widget.session.token,
      },
      body: json.encode(widget.user),
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit user')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully saved user')));
    widget.onUpdate();
    Navigator.pop(context);
  }

  void _deleteUser() async {
    final response = await http.head(
      Uri.http(navi.server, 'user_delete', {'user_id': widget.user.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted user')));
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
          if (widget.user.id != 0) Row(
            children: [
              Expanded(
                child: AppMemberTile(
                  onTap: (member) => {},
                  item: Member.fromUser(widget.user),
                ),
              ),
              if (widget.session.user!.admin_courses) IconButton(
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
            info: Text("Term"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserTerm,
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
          AppButton(
            text: "Save",
            onPressed: _submitUser,
          ),
        ],
      ),
    );
  }
}
