import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';

import 'static/serverUserAdmin.dart' as server;
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
  bool                  _ctrlUserEnabled = false;
  TextEditingController _ctrlUserFirstname = TextEditingController();
  TextEditingController _ctrlUserLastname = TextEditingController();
  TextEditingController _ctrlUserIban = TextEditingController();
  TextEditingController _ctrlUserEmail = TextEditingController();
  TextEditingController _ctrlUserPhone = TextEditingController();
  //TextEditingController _ctrlUserAddress = TextEditingController();
  TextEditingController _ctrlUserBirthday = TextEditingController();
  TextEditingController _ctrlUserGender = TextEditingController();
  TextEditingController _ctrlUserOrganization = TextEditingController();

  UserAdminPageState();

  @override
  void initState() {
    super.initState();
    _applyUser();
  }

  void _applyUser() {
    _ctrlUserKey.text = widget.user.key;
    _ctrlUserEnabled = widget.user.enabled ?? false;
    _ctrlUserFirstname.text = widget.user.firstname;
    _ctrlUserLastname.text = widget.user.lastname;
    _ctrlUserIban.text = widget.user.iban ?? '';
    _ctrlUserEmail.text = widget.user.email ?? '';
    _ctrlUserPhone.text = widget.user.phone ?? '';
    //_ctrlUserAddress.text = widget.user.address ?? '';
    _ctrlUserBirthday.text = widget.user.birthday ?? '';
    _ctrlUserGender.text = widget.user.gender ?? '';
    _ctrlUserOrganization.text = widget.user.organization_id?.toString() ?? '';
  }

  void _gatherUser() {
    widget.user.key = _ctrlUserKey.text;
    widget.user.enabled = _ctrlUserEnabled;
    widget.user.firstname = _ctrlUserFirstname.text;
    widget.user.lastname = _ctrlUserLastname.text;

    widget.user.iban = _ctrlUserIban.text.isNotEmpty ? _ctrlUserIban.text : null;
    widget.user.email = _ctrlUserEmail.text.isNotEmpty ? _ctrlUserEmail.text : null;
    widget.user.phone = _ctrlUserPhone.text.isNotEmpty ? _ctrlUserPhone.text : null;
    widget.user.birthday = _ctrlUserBirthday.text.isNotEmpty ? _ctrlUserBirthday.text : null;
    widget.user.gender = _ctrlUserGender.text.isNotEmpty ? _ctrlUserGender.text : null;
    widget.user.organization_id = int.tryParse(_ctrlUserOrganization.text);
    widget.user.iban = _ctrlUserIban.text.isNotEmpty ? _ctrlUserIban.text : null;
  }

  void _submitUser() async {
    _gatherUser();

    bool success = widget.isDraft ? await server.user_create(widget.session, widget.user) : await server.user_edit(widget.session, widget.user);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit user')));
      return;
    }

    bool? pwdsuccess = await server.user_edit_password(widget.session, widget.user, _ctrlUserPassword.text);
    if (pwdsuccess != null && !pwdsuccess)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User saved, but new password was rejected.')));

    _ctrlUserPassword.text = '';

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
                child: AppUserTile(
                  onTap: (member) => {},
                  user: widget.user,
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
            info: Text("Account Enabled"),
            child: Checkbox(
              value: _ctrlUserEnabled,
              onChanged: (bool? enabled) => setState(() => _ctrlUserEnabled = enabled!),
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
            info: Text("IBAN"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserIban,
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
/*          AppInfoRow(
            info: Text("Address"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserAddress,
            ),
          ),*/
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
