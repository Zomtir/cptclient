import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/DateTimeEdit.dart';
import 'package:cptclient/static/format.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';

import '../static/serverUserAdmin.dart' as server;
import '../json/session.dart';
import '../json/user.dart';

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
  TextEditingController _ctrlUserAddress = TextEditingController();
  TextEditingController _ctrlUserEmail = TextEditingController();
  TextEditingController _ctrlUserPhone = TextEditingController();
  TextEditingController _ctrlUserIban = TextEditingController();
  DateTimeController    _ctrlUserBirthday = DateTimeController();
  TextEditingController _ctrlUserBirthlocation = TextEditingController();
  TextEditingController _ctrlUserNationality = TextEditingController();
  TextEditingController _ctrlUserGender = TextEditingController();
  TextEditingController _ctrlUserFederationNumber = TextEditingController();
  DateTimeController    _ctrlUserFederationPermissionSolo = DateTimeController();
  DateTimeController    _ctrlUserFederationPermissionTeam = DateTimeController();
  DateTimeController    _ctrlUserFederationResidency = DateTimeController();
  TextEditingController _ctrlUserDataDeclaration = TextEditingController();
  TextEditingController _ctrlUserDataDisclaimer = TextEditingController();
  TextEditingController _ctrlUserNote = TextEditingController();

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
    _ctrlUserAddress.text = widget.user.address ?? '';
    _ctrlUserEmail.text = widget.user.email ?? '';
    _ctrlUserPhone.text = widget.user.phone ?? '';
    _ctrlUserIban.text = widget.user.iban ?? '';
    _ctrlUserBirthday.setDateTime(widget.user.birthday);
    _ctrlUserBirthlocation.text = widget.user.birthlocation ?? '';
    _ctrlUserGender.text = widget.user.gender ?? '';
    _ctrlUserNationality.text = widget.user.nationality ?? '';
    _ctrlUserFederationNumber.text = widget.user.federationNumber?.toString() ?? '';
    _ctrlUserFederationPermissionSolo.setDateTime(widget.user.federationPermissionSolo);
    _ctrlUserFederationPermissionTeam.setDateTime(widget.user.federationPermissionTeam);
    _ctrlUserFederationResidency.setDateTime(widget.user.federationResidency);
    _ctrlUserDataDeclaration.text = widget.user.dataDeclaration?.toString() ?? '';
    _ctrlUserDataDisclaimer.text = widget.user.dataDisclaimer ?? '';
    _ctrlUserNote.text = widget.user.note ?? '';
  }

  void _gatherUser() {
    widget.user.key = _ctrlUserKey.text;
    widget.user.enabled = _ctrlUserEnabled;
    widget.user.firstname = _ctrlUserFirstname.text;
    widget.user.lastname = _ctrlUserLastname.text;
    widget.user.address = _ctrlUserAddress.text.isNotEmpty ? _ctrlUserAddress.text : null;
    widget.user.email = _ctrlUserEmail.text.isNotEmpty ? _ctrlUserEmail.text : null;
    widget.user.phone = _ctrlUserPhone.text.isNotEmpty ? _ctrlUserPhone.text : null;
    widget.user.iban = _ctrlUserIban.text.isNotEmpty ? _ctrlUserIban.text : null;
    widget.user.birthday = _ctrlUserBirthday.getDateTime();
    widget.user.birthlocation = _ctrlUserBirthlocation.text.isNotEmpty ? _ctrlUserBirthlocation.text : null;
    widget.user.gender = _ctrlUserGender.text.isNotEmpty ? _ctrlUserGender.text : null;
    widget.user.nationality = _ctrlUserNationality.text.isNotEmpty ? _ctrlUserNationality.text : null;
    widget.user.federationNumber = parseNullInt(_ctrlUserFederationNumber.text);
    widget.user.federationPermissionSolo = _ctrlUserFederationPermissionSolo.getDateTime();
    widget.user.federationPermissionTeam = _ctrlUserFederationPermissionTeam.getDateTime();
    widget.user.federationResidency = _ctrlUserFederationResidency.getDateTime();
    widget.user.dataDeclaration = parseNullInt(_ctrlUserDataDeclaration.text);
    widget.user.dataDisclaimer = _ctrlUserDataDisclaimer.text.isNotEmpty ? _ctrlUserDataDeclaration.text : null;
    widget.user.note = _ctrlUserNote.text.isNotEmpty ? _ctrlUserNote.text : null;
  }

  void _submitUser() async {
    _gatherUser();

    if (widget.user.firstname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('First name is mandatory')));
      return;
    }

    if (widget.user.lastname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Last name is mandatory')));
      return;
    }

    bool success = widget.isDraft ? await server.user_create(widget.session, widget.user) : await server.user_edit(widget.session, widget.user);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit user')));
      return;
    }

    bool? pwdsuccess = await server.user_edit_password(widget.session, widget.user, _ctrlUserPassword.text);
    if (pwdsuccess != null && !pwdsuccess)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The user was saved, but the new password was rejected.')));

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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Checkbox(
                value: _ctrlUserEnabled,
                onChanged: (bool? enabled) => setState(() => _ctrlUserEnabled = enabled!),
              ),
            ),
          ),
          AppInfoRow(
            info: Text("First Name *"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserFirstname,
            ),
          ),
          AppInfoRow(
            info: Text("Last Name *"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserLastname,
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
            info: Text("IBAN"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserIban,
            ),
          ),
          AppInfoRow(
            info: Text("Date of Birth"),
            child: DateTimeEdit(
              nullable: true,
              dateOnly: true,
              controller: _ctrlUserBirthday,
            ),
          ),
          AppInfoRow(
            info: Text("Location of Birth"),
            child: TextField(
              maxLines: 4,
              controller: _ctrlUserBirthlocation,
            ),
          ),
          AppInfoRow(
            info: Text("Nationality"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserNationality,
            ),
          ),
          AppInfoRow(
            info: Text("Gender"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserGender,
            ),
          ),
          AppInfoRow(
            info: Text("Federation Number"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserFederationNumber,
            ),
          ),
          AppInfoRow(
            info: Text("Solo Participation\nPermission Date"),
            child: DateTimeEdit(
              nullable: true,
              dateOnly: true,
              controller: _ctrlUserFederationPermissionSolo,
            ),
          ),
          AppInfoRow(
            info: Text("Team Participation\nPermission Date"),
            child: DateTimeEdit(
              nullable: true,
              dateOnly: true,
              controller: _ctrlUserFederationPermissionTeam,
            ),
          ),
          AppInfoRow(
            info: Text("Moving Date to\nResidency in Federation"),
            child: DateTimeEdit(
              nullable: true,
              dateOnly: true,
              controller: _ctrlUserFederationResidency,
            ),
          ),
          AppInfoRow(
            info: Text("Data Declaration Version"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserDataDeclaration,
            ),
          ),
          AppInfoRow(
            info: Text("Data Declaration Disclaimer"),
            child: TextField(
              maxLines: 8,
              controller: _ctrlUserDataDisclaimer,
            ),
          ),
          AppInfoRow(
            info: Text("Notes"),
            child: TextField(
              maxLines: 8,
              controller: _ctrlUserNote,
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
