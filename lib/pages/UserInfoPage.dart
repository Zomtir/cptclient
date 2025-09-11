import 'package:cptclient/api/admin/user/bankacc.dart' as api_admin;
import 'package:cptclient/api/admin/user/license.dart' as api_admin;
import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/bankacc.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/gender.dart';
import 'package:cptclient/json/license.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/json/valence.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/BankAccountEdit.dart';
import 'package:cptclient/material/dialogs/ChoiceDisplay.dart';
import 'package:cptclient/material/dialogs/ChoiceEdit.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';
import 'package:cptclient/material/dialogs/LicenseEdit.dart';
import 'package:cptclient/material/dialogs/MultiChoiceEdit.dart';
import 'package:cptclient/material/dialogs/PasswordEditDialog.dart';
import 'package:cptclient/material/dialogs/TextEditDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/InfoSection.dart';
import 'package:cptclient/material/widgets/LoadingWidget.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  final UserSession session;
  final int userID;

  UserInfoPage({super.key, required this.session, required this.userID});

  @override
  UserInfoPageState createState() => UserInfoPageState();
}

class UserInfoPageState extends State<UserInfoPage> {
  bool _locked = true;
  User? user_info;

  UserInfoPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _submitUser() async {
    bool success = await api_admin.user_edit(widget.session, user_info!);
    messageFailureOnly(success);
    _update();
  }

  Future<void> _update() async {
    User? info = await api_admin.user_detailed(widget.session, widget.userID);
    if (info == null) {
      Navigator.pop(context);
      return;
    }
    setState(() => user_info = info);
    setState(() => _locked = false);
  }

  void _handleDelete() async {
    if (!await api_admin.user_delete(widget.session, user_info!)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_locked) {
      return LoadingWidget();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageUserDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: AppBody(
        children: [
          InfoSection(
            title: AppLocalizations.of(context)!.labelAccount,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userKey,
            child: ListTile(
              title: Text(user_info!.key),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.key),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.key,
                        minLength: 1,
                        maxLength: 20,
                        onConfirm: (String t) {
                          setState(() => user_info!.key = t);
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userEnabled,
            child: ChoiceDisplay(
              value: Valence.fromBool(user_info!.enabled),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => useAppDialog(
                  context: context,
                  child: ChoiceEdit(
                    value: Valence.fromBool(user_info!.enabled!),
                    onConfirm: (Valence? v) {
                      setState(() => user_info!.enabled = v?.toBool());
                      _submitUser();
                    },
                  ),
                ),
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userActive,
            child: ChoiceDisplay(
              value: Valence.fromBool(user_info!.active!),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => useAppDialog(
                  context: context,
                  child: ChoiceEdit(
                    value: Valence.fromBool(user_info!.active!),
                    onConfirm: (Valence? v) {
                      setState(() => user_info!.active = v?.toBool());
                      _submitUser();
                    },
                  ),
                ),
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userPassword,
            child: ListTile(
              title: (user_info!.credential == null)
                  ? Text(AppLocalizations.of(context)!.labelMissing)
                  : user_info!.credential!.buildInfo(context),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: PasswordEditDialog(
                        initialValue: user_info!.credential,
                        onConfirm: (Credential? cr) async {
                          if (user_info!.credential == null && cr == null) {
                            return;
                          } else if (user_info!.credential == null && cr != null) {
                            await api_admin.user_password_create(widget.session, user_info!, cr.password!, cr.salt!);
                          } else if (user_info!.credential != null && cr == null) {
                            await api_admin.user_password_delete(widget.session, user_info!);
                          } else if (user_info!.credential != null && cr != null) {
                            await api_admin.user_password_edit(widget.session, user_info!, cr.password!, cr.salt!);
                          }
                          _update();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelName,
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userFirstname}",
            child: ListTile(
              title: Text(user_info!.firstname),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.firstname),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.firstname,
                        minLength: 1,
                        maxLength: 20,
                        onConfirm: (String t) {
                          setState(() => user_info!.firstname = t);
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userLastname}",
            child: ListTile(
              title: Text(user_info!.lastname),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.lastname),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.lastname,
                        minLength: 1,
                        maxLength: 20,
                        onConfirm: (String t) {
                          setState(() => user_info!.lastname = t);
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userNickname}",
            child: ListTile(
              title: Text(user_info!.nickname ?? AppLocalizations.of(context)!.labelMissing),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.nickname ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.nickname ?? '',
                        minLength: 1,
                        maxLength: 20,
                        onConfirm: (String? t) {
                          setState(() => user_info!.nickname = (t?.isEmpty ?? true ? null : t));
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelContact,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userAddress,
            child: ListTile(
              title: Text(user_info!.address ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.address ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.address ?? '',
                        minLength: 2,
                        maxLength: 60,
                        onConfirm: (String? t) {
                          setState(() => user_info!.address = (t?.isEmpty ?? true ? null : t));
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userEmail,
            child: ListTile(
              title: Text(user_info!.email ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.email ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.email ?? '',
                        minLength: 3,
                        maxLength: 40,
                        onConfirm: (String? t) {
                          setState(() => user_info!.email = (t?.isEmpty ?? true ? null : t));
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userPhone,
            child: ListTile(
              title: Text(user_info!.phone ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.phone ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.phone ?? '',
                        minLength: 4,
                        maxLength: 20,
                        onReset: () {
                          setState(() => user_info!.phone = null);
                          _submitUser();
                        },
                        onConfirm: (String text) {
                          setState(() => user_info!.phone = text);
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelPersonalBackground,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userBirthDate,
            child: ListTile(
              title: Text(user_info!.birth_date?.fmtDate(context) ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(formatIsoDate(user_info!.birth_date) ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: DatePicker(
                        initialDate: user_info!.birth_date,
                        onConfirm: (DateTime? dt) {
                          setState(() => user_info!.birth_date = dt);
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userBirthLocation,
            child: ListTile(
              title: Text(user_info!.birth_location ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.birth_location ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.birth_location ?? '',
                        minLength: 2,
                        maxLength: 60,
                        onConfirm: (String? t) {
                          setState(() => user_info!.birth_location = (t?.isEmpty ?? true ? null : t));
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userNationality,
            child: ListTile(
              title: Text(user_info!.nationality ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.nationality ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.nationality ?? '',
                        minLength: 2,
                        maxLength: 40,
                        onReset: () {
                          setState(() => user_info!.nationality = null);
                          _submitUser();
                        },
                        onConfirm: (String t) {
                          setState(() => user_info!.nationality = t);
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelPhysicalCharacteristics,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userGender,
            child: ListTile(
              title: Text(user_info!.gender?.localizedName(context) ?? AppLocalizations.of(context)!.labelMissing),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.gender?.localizedName(context) ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: MultiChoiceEdit<Gender>(
                        items: Gender.values,
                        value: user_info!.gender,
                        builder: (gender) => gender.buildTile(context),
                        onReset: () {
                          setState(() => user_info!.gender = null);
                          _submitUser();
                        },
                        onConfirm: (Gender? g) {
                          setState(() => user_info!.gender = g);
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userHeight,
            child: ListTile(
              title: Text(user_info!.height != null ? "${user_info!.height} cm" : ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.height?.toString() ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.height?.toString() ?? '',
                        minLength: 1,
                        maxLength: 3,
                        onReset: () {
                          setState(() => user_info!.height = null);
                          _submitUser();
                        },
                        onConfirm: (String t) {
                          int? height = int.tryParse(t);
                          if (height == null) {
                            messageText("Failed to parse the input");
                            return;
                          }
                          setState(() => user_info!.height = height);
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userWeight,
            child: ListTile(
              title: Text(user_info!.weight != null ? "${user_info!.weight} kg" : ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(user_info!.weight?.toString() ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.weight?.toString() ?? '',
                        minLength: 1,
                        maxLength: 3,
                        onReset: () {
                          setState(() => user_info!.weight = null);
                          _submitUser();
                        },
                        onConfirm: (String t) {
                          int? weight = int.tryParse(t);
                          if (weight == null) {
                            messageText("Failed to parse the input");
                            return;
                          }
                          setState(() => user_info!.weight = weight);
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelMiscellaneous,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userNote,
            child: ListTile(
              title: Text(user_info!.note ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () => clipText(user_info!.note ?? ''),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog(
                      context: context,
                      child: TextEditDialog(
                        initialValue: user_info!.note ?? '',
                        minLength: 0,
                        maxLength: 20,
                        onReset: () {
                          setState(() => user_info!.note = null);
                          _submitUser();
                        },
                        onConfirm: (String t) {
                          setState(() => user_info!.note = (t.isEmpty ? null : t));
                          _submitUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userBankacc,
            child: user_info!.bank_account == null
                ? ListTile(
                    title: Text(AppLocalizations.of(context)!.labelMissing),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => useAppDialog(
                        context: context,
                        child: BankAccountEdit(
                          initialValue: BankAccount.fromVoid(),
                          onConfirm: (BankAccount ba) async {
                            await api_admin.user_bank_account_create(widget.session, user_info!, ba);
                            _update();
                          },
                        ),
                      ),
                    ),
                  )
                : ListTile(
                    title: user_info!.bank_account!.buildInfo(context),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () => clipText(user_info!.bank_account!.clip(context)),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => useAppDialog(
                            context: context,
                            child: BankAccountEdit(
                              initialValue: user_info!.bank_account!,
                              onDelete: () async {
                                await api_admin.user_bank_account_delete(widget.session, user_info!);
                                _update();
                              },
                              onConfirm: (BankAccount ba) async {
                                await api_admin.user_bank_account_edit(widget.session, user_info!, ba);
                                _update();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userLicenseMain,
            child: user_info!.license_main == null
                ? ListTile(
                    title: Text(AppLocalizations.of(context)!.labelMissing),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => useAppDialog(
                        context: context,
                        child: LicenseEdit(
                          initialValue: License.fromVoid(),
                          onConfirm: (License lic) async {
                            await api_admin.user_license_main_create(widget.session, user_info!, lic);
                            _update();
                          },
                        ),
                      ),
                    ),
                  )
                : ListTile(
                    title: user_info!.license_main!.buildInfo(context),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () => clipText(user_info!.license_main!.clip(context)),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => useAppDialog(
                            context: context,
                            child: LicenseEdit(
                              initialValue: user_info!.license_main!,
                              onDelete: () async {
                                await api_admin.user_license_main_delete(widget.session, user_info!);
                                _update();
                              },
                              onConfirm: (License lic) async {
                                await api_admin.user_license_main_edit(widget.session, user_info!, lic);
                                _update();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userLicenseExtra,
            child: user_info!.license_extra == null
                ? ListTile(
                    title: Text(AppLocalizations.of(context)!.labelMissing),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => useAppDialog(
                        context: context,
                        child: LicenseEdit(
                          initialValue: License.fromVoid(),
                          onConfirm: (License lic) async {
                            await api_admin.user_license_extra_create(widget.session, user_info!, lic);
                            _update();
                          },
                        ),
                      ),
                    ),
                  )
                : ListTile(
                    title: user_info!.license_extra!.buildInfo(context),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () => clipText(user_info!.license_extra!.clip(context)),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => useAppDialog(
                            context: context,
                            child: LicenseEdit(
                              initialValue: user_info!.license_extra!,
                              onDelete: () async {
                                await api_admin.user_license_extra_delete(widget.session, user_info!);
                                _update();
                              },
                              onConfirm: (License lic) async {
                                await api_admin.user_license_extra_edit(widget.session, user_info!, lic);
                                _update();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
