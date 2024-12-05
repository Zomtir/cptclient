import 'package:cptclient/api/admin/user/bankacc.dart' as api_admin;
import 'package:cptclient/api/admin/user/license.dart' as api_admin;
import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/bankacc.dart';
import 'package:cptclient/json/gender.dart';
import 'package:cptclient/json/license.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/AttributeField.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:cptclient/pages/UserBankAccountPage.dart';
import 'package:cptclient/pages/UserLicensePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserEditPage extends StatefulWidget {
  final UserSession session;
  final int userID;
  final bool isDraft;

  UserEditPage({super.key, required this.session, required this.userID, required this.isDraft});

  @override
  UserEditPageState createState() => UserEditPageState();
}

class UserEditPageState extends State<UserEditPage> {
  User user_info = User.fromVoid();

  final TextEditingController _ctrlUserKey = TextEditingController();
  final TextEditingController _ctrlUserPassword = TextEditingController();
  bool _ctrlUserEnabled = false;
  bool _ctrlUserActive = true;
  final TextEditingController _ctrlUserFirstname = TextEditingController();
  final TextEditingController _ctrlUserLastname = TextEditingController();
  final TextEditingController _ctrlUserNickname = TextEditingController();
  final TextEditingController _ctrlUserAddress = TextEditingController();
  final TextEditingController _ctrlUserEmail = TextEditingController();
  final TextEditingController _ctrlUserPhone = TextEditingController();
  final DateTimeController _ctrlUserBirthDate = DateTimeController();
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
    _update();
  }

  Future<void> _update() async {
    if (!widget.isDraft) {
      User? info = await api_admin.user_detailed(widget.session, widget.userID);
      if (info == null) {
        Navigator.pop(context);
        return;
      }
      setState(() => user_info = info);
    }
    _applyUser();
  }

  void _applyUser() {
    _ctrlUserKey.text = user_info.key;
    _ctrlUserEnabled = user_info.enabled ?? false;
    _ctrlUserActive = user_info.active ?? false;
    _ctrlUserFirstname.text = user_info.firstname;
    _ctrlUserLastname.text = user_info.lastname;
    _ctrlUserNickname.text = user_info.nickname ?? '';
    _ctrlUserAddress.text = user_info.address ?? '';
    _ctrlUserEmail.text = user_info.email ?? '';
    _ctrlUserPhone.text = user_info.phone ?? '';
    _ctrlUserBirthDate.setDateTime(user_info.birth_date);
    _ctrlUserBirthLocation.text = user_info.birth_location ?? '';
    _ctrlUserGender.value = user_info.gender;
    _ctrlUserNationality.text = user_info.nationality ?? '';
    _ctrlUserHeight.text = user_info.height?.toString() ?? '';
    _ctrlUserWeight.text = user_info.weight?.toString() ?? '';
    _ctrlUserNote.text = user_info.note ?? '';
  }

  void _gatherUser() {
    user_info.key = _ctrlUserKey.text;
    user_info.enabled = _ctrlUserEnabled;
    user_info.active = _ctrlUserActive;
    user_info.firstname = _ctrlUserFirstname.text;
    user_info.lastname = _ctrlUserLastname.text;
    user_info.nickname = _ctrlUserNickname.text.isNotEmpty ? _ctrlUserNickname.text : null;
    user_info.address = _ctrlUserAddress.text.isNotEmpty ? _ctrlUserAddress.text : null;
    user_info.email = _ctrlUserEmail.text.isNotEmpty ? _ctrlUserEmail.text : null;
    user_info.phone = _ctrlUserPhone.text.isNotEmpty ? _ctrlUserPhone.text : null;
    user_info.birth_date = _ctrlUserBirthDate.getDateTime();
    user_info.birth_location = _ctrlUserBirthLocation.text.isNotEmpty ? _ctrlUserBirthLocation.text : null;
    user_info.gender = _ctrlUserGender.value;
    user_info.nationality = _ctrlUserNationality.text.isNotEmpty ? _ctrlUserNationality.text : null;
    user_info.height = int.tryParse(_ctrlUserHeight.text);
    user_info.weight = int.tryParse(_ctrlUserWeight.text);
    user_info.note = _ctrlUserNote.text.isNotEmpty ? _ctrlUserNote.text : null;
  }

  void _submitUser() async {
    _gatherUser();

    if (user_info.firstname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.userFirstname} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (user_info.lastname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.userLastname} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.user_create(widget.session, user_info)
        : await api_admin.user_edit(widget.session, user_info);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
      return;
    }

    Navigator.pop(context);
  }

  void _handleDelete() async {
    if (!await api_admin.user_delete(widget.session, user_info)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
      return;
    }

    Navigator.pop(context);
  }

  void _handlePasswordChange() async {
    bool? success = await api_admin.user_edit_password(widget.session, user_info, _ctrlUserPassword.text);
    if (success != null && !success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
    }

    _ctrlUserPassword.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageUserEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            Row(
              children: [
                Expanded(
                  child: AppUserTile(
                    user: user_info,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _handleDelete,
                ),
              ],
            ),
          if (!widget.isDraft)
            AppInfoRow(
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
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _submitUser,
          ),
          if (!widget.isDraft) Divider(),
          if (!widget.isDraft)
            AppInfoRow(
              info: AppLocalizations.of(context)!.userBankacc,
              child: AttributeField<BankAccount>(
                attribute: user_info.bank_account,
                onCreate: () async {
                  await api_admin.user_bank_account_create(widget.session, user_info, BankAccount.fromVoid());
                  _update();
                },
                onEdit: (BankAccount ba) async {
                  await api_admin.user_bank_account_edit(widget.session, user_info, ba);
                  _update();
                },
                onDelete: () async {
                  await api_admin.user_bank_account_delete(widget.session, user_info);
                  _update();
                },
                builder: (context, onEdit) => UserBankAccountPage(bankacc: user_info.bank_account!, onEdit: onEdit),
              ),
            ),
          if (!widget.isDraft)
            AppInfoRow(
              info: AppLocalizations.of(context)!.userLicenseMain,
              child: AttributeField<License>(
                attribute: user_info.license_main,
                onCreate: () async {
                  await api_admin.user_license_main_create(widget.session, user_info, License.fromVoid());
                  _update();
                },
                onEdit: (License lic) async {
                  await api_admin.user_license_main_edit(widget.session, user_info, lic);
                  _update();
                },
                onDelete: () async {
                  await api_admin.user_license_main_delete(widget.session, user_info);
                  _update();
                },
                builder: (context, onEdit) => UserLicensePage(license: user_info.license_main!, onEdit: onEdit),
              ),
            ),
          if (!widget.isDraft)
            AppInfoRow(
              info: AppLocalizations.of(context)!.userLicenseExtra,
              child: AttributeField<License>(
                attribute: user_info.license_extra,
                onCreate: () async {
                  await api_admin.user_license_extra_create(widget.session, user_info, License.fromVoid());
                  _update();
                },
                onEdit: (License lic) async {
                  await api_admin.user_license_extra_edit(widget.session, user_info, lic);
                  _update();
                },
                onDelete: () async {
                  await api_admin.user_license_extra_delete(widget.session, user_info);
                  _update();
                },
                builder: (context, onEdit) => UserLicensePage(license: user_info.license_extra!, onEdit: onEdit),
              ),
            ),
          if (!widget.isDraft)
            AppInfoRow(
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
