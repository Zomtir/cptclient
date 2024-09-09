import 'package:cptclient/api/admin/user/user.dart' as server;
import 'package:cptclient/json/gender.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserEditPage extends StatefulWidget {
  final UserSession session;
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
  final DateTimeController    _ctrlUserBirthDate = DateTimeController();
  final TextEditingController _ctrlUserBirthLocation = TextEditingController();
  final TextEditingController _ctrlUserNationality = TextEditingController();
  final DropdownController<Gender> _ctrlUserGender = DropdownController<Gender>(items: Gender.values);
  final TextEditingController _ctrlUserHeight = TextEditingController();
  final TextEditingController _ctrlUserWeight = TextEditingController();
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
    _ctrlUserBirthDate.setDateTime(widget.user.birth_date);
    _ctrlUserBirthLocation.text = widget.user.birth_location ?? '';
    _ctrlUserGender.value = widget.user.gender;
    _ctrlUserNationality.text = widget.user.nationality ?? '';
    _ctrlUserHeight.text = widget.user.height?.toString() ?? '';
    _ctrlUserWeight.text = widget.user.weight?.toString() ?? '';
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
    widget.user.birth_date = _ctrlUserBirthDate.getDateTime();
    widget.user.birth_location = _ctrlUserBirthLocation.text.isNotEmpty ? _ctrlUserBirthLocation.text : null;
    widget.user.gender = _ctrlUserGender.value;
    widget.user.nationality = _ctrlUserNationality.text.isNotEmpty ? _ctrlUserNationality.text : null;
    widget.user.height = int.tryParse(_ctrlUserHeight.text);
    widget.user.weight = int.tryParse(_ctrlUserWeight.text);
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

  void _handleDelete() async {
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
        title: Text(AppLocalizations.of(context)!.pageUserEdit),
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
                onPressed: _handleDelete,
              ),
            ],
          ),
          if (!widget.isDraft) AppInfoRow(
            info: AppLocalizations.of(context)!.userKey,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserKey,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userEnabled,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Checkbox(
                value: _ctrlUserEnabled,
                onChanged: (bool? enabled) => setState(() => _ctrlUserEnabled = enabled!),
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userActive,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Checkbox(
                value: _ctrlUserActive,
                onChanged: (bool? active) => setState(() => _ctrlUserActive = active!),
              ),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userFirstname} *",
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserFirstname,
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userLastname} *",
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserLastname,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userNickname,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserNickname,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userAddress,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserAddress,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userEmail,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserEmail,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userPhone,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserPhone,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userIban,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserIban,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userBirthDate,
            child: DateTimeEdit(
              nullable: true,
              showTime: false,
              controller: _ctrlUserBirthDate,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userBirthLocation,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserBirthLocation,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userNationality,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserNationality,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userGender,
            child: AppDropdown<Gender>(
              controller: _ctrlUserGender,
              builder: (Gender gender) => Text(gender.localizedName(context)),
              onChanged: (Gender? gender) => setState(() => _ctrlUserGender.value = gender),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userHeight,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserHeight,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userWeight,
            child: TextField(
              maxLines: 1,
              controller: _ctrlUserWeight,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userNote,
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
            info: AppLocalizations.of(context)!.userPassword,
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
