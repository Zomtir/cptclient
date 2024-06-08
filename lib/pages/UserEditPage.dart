import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/server_user_admin.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserEditPage extends StatefulWidget {
  final Session session;
  final User user;
  final bool isDraft;

  UserEditPage({super.key, required this.session, required this.user, required this.isDraft});

  @override
  UserEditPageState createState() => UserEditPageState();
}

class UserEditPageState extends State<UserEditPage> {
  final TextEditingController _ctrlUserKey = TextEditingController();
  final TextEditingController _ctrlUserPassword = TextEditingController();
  bool                  _ctrlUserEnabled = false;
  bool                  _ctrlUserActive = true;
  final TextEditingController _ctrlUserFirstname = TextEditingController();
  final TextEditingController _ctrlUserLastname = TextEditingController();
  final TextEditingController _ctrlUserNickname = TextEditingController();
  final TextEditingController _ctrlUserAddress = TextEditingController();
  final TextEditingController _ctrlUserEmail = TextEditingController();
  final TextEditingController _ctrlUserPhone = TextEditingController();
  final TextEditingController _ctrlUserIban = TextEditingController();
  final DateTimeController    _ctrlUserBirthday = DateTimeController();
  final TextEditingController _ctrlUserBirthlocation = TextEditingController();
  final TextEditingController _ctrlUserNationality = TextEditingController();
  final TextEditingController _ctrlUserGender = TextEditingController();
  final TextEditingController _ctrlUserFederationNumber = TextEditingController();
  final DateTimeController    _ctrlUserFederationPermissionSolo = DateTimeController();
  final DateTimeController    _ctrlUserFederationPermissionTeam = DateTimeController();
  final DateTimeController    _ctrlUserFederationResidency = DateTimeController();
  final TextEditingController _ctrlUserDataDeclaration = TextEditingController();
  final TextEditingController _ctrlUserDataDisclaimer = TextEditingController();
  final TextEditingController _ctrlUserNote = TextEditingController();

  UserEditPageState();

  @override
  void initState() {
    super.initState();
    _applyUser();
  }

  void _applyUser() {
    _ctrlUserKey.text = widget.user.key;
    _ctrlUserEnabled = widget.user.enabled ?? false;
    _ctrlUserActive = widget.user.active ?? false;
    _ctrlUserFirstname.text = widget.user.firstname;
    _ctrlUserLastname.text = widget.user.lastname;
    _ctrlUserNickname.text = widget.user.nickname ?? '';
    _ctrlUserAddress.text = widget.user.address ?? '';
    _ctrlUserEmail.text = widget.user.email ?? '';
    _ctrlUserPhone.text = widget.user.phone ?? '';
    _ctrlUserIban.text = widget.user.iban ?? '';
    _ctrlUserBirthday.setDateTime(widget.user.birthday);
    _ctrlUserBirthlocation.text = widget.user.birthlocation ?? '';
    _ctrlUserGender.text = widget.user.gender ?? '';
    _ctrlUserNationality.text = widget.user.nationality ?? '';
    _ctrlUserFederationNumber.text = widget.user.federationnumber?.toString() ?? '';
    _ctrlUserFederationPermissionSolo.setDateTime(widget.user.federationpermissionsolo);
    _ctrlUserFederationPermissionTeam.setDateTime(widget.user.federationpermissionteam);
    _ctrlUserFederationResidency.setDateTime(widget.user.federationresidency);
    _ctrlUserDataDeclaration.text = widget.user.datadeclaration?.toString() ?? '';
    _ctrlUserDataDisclaimer.text = widget.user.datadisclaimer ?? '';
    _ctrlUserNote.text = widget.user.note ?? '';
  }

  void _gatherUser() {
    widget.user.key = _ctrlUserKey.text;
    widget.user.enabled = _ctrlUserEnabled;
    widget.user.active = _ctrlUserActive;
    widget.user.firstname = _ctrlUserFirstname.text;
    widget.user.lastname = _ctrlUserLastname.text;
    widget.user.nickname = _ctrlUserNickname.text.isNotEmpty ? _ctrlUserNickname.text : null;
    widget.user.address = _ctrlUserAddress.text.isNotEmpty ? _ctrlUserAddress.text : null;
    widget.user.email = _ctrlUserEmail.text.isNotEmpty ? _ctrlUserEmail.text : null;
    widget.user.phone = _ctrlUserPhone.text.isNotEmpty ? _ctrlUserPhone.text : null;
    widget.user.iban = _ctrlUserIban.text.isNotEmpty ? _ctrlUserIban.text : null;
    widget.user.birthday = _ctrlUserBirthday.getDateTime();
    widget.user.birthlocation = _ctrlUserBirthlocation.text.isNotEmpty ? _ctrlUserBirthlocation.text : null;
    widget.user.gender = _ctrlUserGender.text.isNotEmpty ? _ctrlUserGender.text : null;
    widget.user.nationality = _ctrlUserNationality.text.isNotEmpty ? _ctrlUserNationality.text : null;
    widget.user.federationnumber = parseNullInt(_ctrlUserFederationNumber.text);
    widget.user.federationpermissionsolo = _ctrlUserFederationPermissionSolo.getDateTime();
    widget.user.federationpermissionteam = _ctrlUserFederationPermissionTeam.getDateTime();
    widget.user.federationresidency = _ctrlUserFederationResidency.getDateTime();
    widget.user.datadeclaration = parseNullInt(_ctrlUserDataDeclaration.text);
    widget.user.datadisclaimer = _ctrlUserDataDisclaimer.text.isNotEmpty ? _ctrlUserDataDeclaration.text : null;
    widget.user.note = _ctrlUserNote.text.isNotEmpty ? _ctrlUserNote.text : null;
  }

  void _submitUser() async {
    _gatherUser();

    if (widget.user.firstname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${AppLocalizations.of(context)!.userFirstname} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (widget.user.lastname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${AppLocalizations.of(context)!.userLastname} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft ? await server.user_create(widget.session, widget.user) : await server.user_edit(widget.session, widget.user);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
      return;
    }

    Navigator.pop(context);
  }

  void _deleteUser() async {
    if (!await server.user_delete(widget.session, widget.user)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
      return;
    }

    Navigator.pop(context);
  }

  void _handlePasswordChange() async {
    bool? success = await server.user_edit_password(widget.session, widget.user, _ctrlUserPassword.text);
    if (success != null && !success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
    }

    _ctrlUserPassword.text = '';
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
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
          if (!widget.isDraft) AppInfoRow(
            info: Text("Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserKey,
            ),
          ),
          AppInfoRow(
            info: Text("Login Enabled"),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Checkbox(
                value: _ctrlUserEnabled,
                onChanged: (bool? enabled) => setState(() => _ctrlUserEnabled = enabled!),
              ),
            ),
          ),
          AppInfoRow(
            info: Text("Active Participation"),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Checkbox(
                value: _ctrlUserActive,
                onChanged: (bool? active) => setState(() => _ctrlUserActive = active!),
              ),
            ),
          ),
          AppInfoRow(
            info: Text("${AppLocalizations.of(context)!.userFirstname} *"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserFirstname,
            ),
          ),
          AppInfoRow(
            info: Text("${AppLocalizations.of(context)!.userLastname} *"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserLastname,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.userNickname),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserNickname,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.userAddress),
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
            info: Text(AppLocalizations.of(context)!.userBirthday),
            child: DateTimeEdit(
              nullable: true,
              showTime: false,
              controller: _ctrlUserBirthday,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.userBirthlocation),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserBirthlocation,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.userNationality),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserNationality,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.userGender),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserGender,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.userFederationNumber),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserFederationNumber,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.userParicipationDateSolo),
            child: DateTimeEdit(
              nullable: true,
              showTime: false,
              controller: _ctrlUserFederationPermissionSolo,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.userParicipationDateTeam),
            child: DateTimeEdit(
              nullable: true,
              showTime: false,
              controller: _ctrlUserFederationPermissionTeam,
            ),
          ),
          AppInfoRow(
            info: Text("Moving Date to\nResidency in Federation"),
            child: DateTimeEdit(
              nullable: true,
              showTime: false,
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
            info: Text(AppLocalizations.of(context)!.userNote),
            child: TextField(
              maxLines: 8,
              controller: _ctrlUserNote,
            ),
          ),
          AppButton(
            text: "Save",
            onPressed: _submitUser,
          ),
          if (!widget.isDraft) Divider(),
          if (!widget.isDraft) AppInfoRow(
            info: Text(AppLocalizations.of(context)!.userPassword),
            child: TextField(
              obscureText: true,
              maxLines: 1,
              controller: _ctrlUserPassword,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.userPasswordChange,
                suffixIcon: IconButton(
                  onPressed: _handlePasswordChange,
                  icon: Icon(Icons.save),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
