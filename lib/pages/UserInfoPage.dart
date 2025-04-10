import 'package:cptclient/api/admin/user/bankacc.dart' as api_admin;
import 'package:cptclient/api/admin/user/license.dart' as api_admin;
import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/bankacc.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/gender.dart';
import 'package:cptclient/json/license.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/BankAccountEdit.dart';
import 'package:cptclient/material/dialogs/ChoiceWidget.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';
import 'package:cptclient/material/dialogs/LicenseEdit.dart';
import 'package:cptclient/material/dialogs/MultiChoiceEdit.dart';
import 'package:cptclient/material/dialogs/PasswordPicker.dart';
import 'package:cptclient/material/dialogs/TextEdit.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/InfoSection.dart';
import 'package:cptclient/material/widgets/LoadingWidget.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        title: Text(AppLocalizations.of(context)!.pageUserEdit),
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.key)),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.key,
                        minLength: 1,
                        maxLength: 20,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.key = t);
                        _submitUser();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userEnabled,
            child: ChoiceDisplayWidget(
              enabled: true,
              value: user_info!.enabled!,
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => useAppDialog<(bool, bool?)>(
                  context: context,
                  widget: ChoiceEditWidget(enabled: true, value: user_info!.enabled!),
                  onChanged: ((bool, bool?) t) {
                    setState(() => user_info!.enabled = t.$2!);
                    _submitUser();
                  },
                ),
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userActive,
            child: ChoiceDisplayWidget(
              enabled: true,
              value: user_info!.active!,
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => useAppDialog<(bool, bool?)>(
                  context: context,
                  widget: ChoiceEditWidget(enabled: true, value: user_info!.active!),
                  onChanged: ((bool, bool?) t) {
                    setState(() => user_info!.active = t.$2!);
                    _submitUser();
                  },
                ),
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userPassword,
            child: ListTile(
              title: Credential.buildEntryStatic(context, user_info!.credential),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<Credential?>(
                      context: context,
                      widget: PasswordPicker(credits: user_info!.credential),
                      onChanged: (Credential? cr) async {
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.firstname)),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.firstname,
                        minLength: 1,
                        maxLength: 20,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.firstname = t);
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.lastname)),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.lastname,
                        minLength: 1,
                        maxLength: 20,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.lastname = t);
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.nickname ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.nickname ?? '',
                        minLength: 0,
                        maxLength: 20,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.nickname = (t.isEmpty ? null : t));
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.address ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.address ?? '',
                        minLength: 0,
                        maxLength: 60,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.address = (t.isEmpty ? null : t));
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.email ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.email ?? '',
                        minLength: 0,
                        maxLength: 40,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.email = (t.isEmpty ? null : t));
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.phone ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.phone ?? '',
                        minLength: 0,
                        maxLength: 20,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.phone = (t.isEmpty ? null : t));
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: formatIsoDate(user_info!.birth_date) ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => useAppDialog<DateTime?>(
                      context: context,
                      widget: DatePicker(initialDate: user_info!.birth_date),
                      onChanged: (DateTime? dt) {
                        setState(() => user_info!.birth_date = dt);
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.birth_location ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.birth_location ?? '',
                        minLength: 0,
                        maxLength: 60,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.birth_location = (t.isEmpty ? null : t));
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.nationality ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.nationality ?? '',
                        minLength: 0,
                        maxLength: 40,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.nationality = (t.isEmpty ? null : t));
                        _submitUser();
                      },
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
                    onPressed: () =>
                        Clipboard.setData(ClipboardData(text: user_info!.gender?.localizedName(context) ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<Gender?>(
                      context: context,
                      widget: MultiChoiceEdit<Gender>(
                        items: Gender.values,
                        value: user_info!.gender,
                        nullable: true,
                      ),
                      onChanged: (Gender? g) {
                        setState(() => user_info!.gender = g);
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.height?.toString() ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.height?.toString() ?? '',
                        minLength: 0,
                        maxLength: 3,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.height = int.tryParse(t));
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.weight?.toString() ?? '')),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.weight?.toString() ?? '',
                        minLength: 0,
                        maxLength: 3,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.weight = int.tryParse(t));
                        _submitUser();
                      },
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
                    onPressed: () => Clipboard.setData(ClipboardData(text: user_info!.note ?? '')),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: user_info!.note ?? '',
                        minLength: 1,
                        maxLength: 20,
                      ),
                      onChanged: (String t) {
                        setState(() => user_info!.note = (t.isEmpty ? null : t));
                        _submitUser();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userBankacc,
            child: ListTile(
              title: BankAccount.buildEntryStatic(context, user_info!.bank_account),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () => Clipboard.setData(
                        ClipboardData(text: BankAccount.copyEntryStatic(context, user_info!.bank_account))),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<BankAccount?>(
                      context: context,
                      widget: BankAccountEdit(bankacc: user_info!.bank_account ?? BankAccount.fromVoid()),
                      onChanged: (BankAccount? ba) async {
                        if (user_info!.bank_account == null && ba == null) {
                          return;
                        } else if (user_info!.bank_account == null && ba != null) {
                          await api_admin.user_bank_account_create(widget.session, user_info!, ba);
                        } else if (user_info!.bank_account != null && ba == null) {
                          await api_admin.user_bank_account_delete(widget.session, user_info!);
                        } else if (user_info!.bank_account != null && ba != null) {
                          await api_admin.user_bank_account_edit(widget.session, user_info!, ba);
                        }
                        _update();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userLicenseMain,
            child: ListTile(
              title: License.buildEntryStatic(context, user_info!.license_main),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () => Clipboard.setData(
                        ClipboardData(text: License.copyEntryStatic(context, user_info!.license_main))),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<License?>(
                      context: context,
                      widget: LicenseEdit(license: user_info!.license_main ?? License.fromVoid()),
                      onChanged: (License? lic) async {
                        if (user_info!.license_main == null && lic == null) {
                          return;
                        } else if (user_info!.license_main == null && lic != null) {
                          await api_admin.user_license_main_create(widget.session, user_info!, lic);
                        } else if (user_info!.license_main != null && lic == null) {
                          await api_admin.user_license_main_delete(widget.session, user_info!);
                        } else if (user_info!.license_main != null && lic != null) {
                          await api_admin.user_license_main_edit(widget.session, user_info!, lic);
                        }
                        _update();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userLicenseExtra,
            child: ListTile(
              title: License.buildEntryStatic(context, user_info!.license_extra),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () => Clipboard.setData(
                        ClipboardData(text: License.copyEntryStatic(context, user_info!.license_extra))),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<License?>(
                      context: context,
                      widget: LicenseEdit(license: user_info!.license_extra ?? License.fromVoid()),
                      onChanged: (License? lic) async {
                        if (user_info!.license_extra == null && lic == null) {
                          return;
                        } else if (user_info!.license_extra == null && lic != null) {
                          await api_admin.user_license_extra_create(widget.session, user_info!, lic);
                        } else if (user_info!.license_extra != null && lic == null) {
                          await api_admin.user_license_extra_delete(widget.session, user_info!);
                        } else if (user_info!.license_extra != null && lic != null) {
                          await api_admin.user_license_extra_edit(widget.session, user_info!, lic);
                        }
                        _update();
                      },
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
