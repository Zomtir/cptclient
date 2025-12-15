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
import 'package:cptclient/material/dialogs/BankAccountEdit.dart';
import 'package:cptclient/material/dialogs/ChoiceEdit.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';
import 'package:cptclient/material/dialogs/LicenseEdit.dart';
import 'package:cptclient/material/dialogs/MultiChoiceEdit.dart';
import 'package:cptclient/material/dialogs/PasswordEditDialog.dart';
import 'package:cptclient/material/dialogs/TextEditDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/InfoSection.dart';
import 'package:cptclient/material/widgets/ChoiceDisplay.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatefulWidget {
  final UserSession session;
  final int userID;

  UserDetailPage({super.key, required this.session, required this.userID});

  @override
  UserDetailPageState createState() => UserDetailPageState();
}

class UserDetailPageState extends State<UserDetailPage> {
  bool _locked = true;
  User? user_info;

  UserDetailPageState();

  @override
  void initState() {
    super.initState();
    update();
  }

  Future<void> submit() async {
    await api_admin.user_edit(widget.session, user_info!);
    update();
  }

  Future<void> update() async {
    setState(() => _locked = true);
    Result<User> result_user = await api_admin.user_detailed(widget.session, widget.userID);
    if (result_user is! Success) return;
    if (!mounted) return;
    setState(() {
      user_info = result_user.unwrap();
      _locked = false;
    });
  }

  void delete() async {
    var result = await api_admin.user_delete(widget.session, user_info!);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageUserDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: delete,
          ),
        ],
      ),
      body: AppBody(
        locked: _locked,
        children: [
          InfoSection(
            title: AppLocalizations.of(context)!.labelAccount,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userKey,
            child: Text(user_info!.key),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.key),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.key,
                    minLength: 1,
                    maxLength: 20,
                    onConfirm: (String t) {
                      setState(() => user_info!.key = t);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userEnabled,
            child: ChoiceDisplay(value: Valence.fromBool(user_info!.enabled)),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ChoiceEdit(
                    value: Valence.fromBool(user_info!.enabled!),
                    onConfirm: (Valence? v) {
                      setState(() => user_info!.enabled = v?.toBool());
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userActive,
            child: ChoiceDisplay(value: Valence.fromBool(user_info!.active!)),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ChoiceEdit(
                    value: Valence.fromBool(user_info!.active!),
                    onConfirm: (Valence? v) {
                      setState(() => user_info!.active = v?.toBool());
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userPassword,
            child: (user_info!.credential == null)
                ? Text(AppLocalizations.of(context)!.labelMissing)
                : user_info!.credential!.buildInfo(context),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => PasswordEditDialog(
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
                      update();
                    },
                  ),
                ),
              ),
            ],
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelName,
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userFirstname}",
            child: Text(user_info!.firstname),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.firstname),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.firstname,
                    minLength: 1,
                    maxLength: 20,
                    onConfirm: (String t) {
                      setState(() => user_info!.firstname = t);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userLastname}",
            child: Text(user_info!.lastname),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.lastname),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.lastname,
                    minLength: 1,
                    maxLength: 20,
                    onConfirm: (String t) {
                      setState(() => user_info!.lastname = t);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userNickname}",
            child: Text(user_info!.nickname ?? AppLocalizations.of(context)!.labelMissing),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.nickname ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.nickname ?? '',
                    minLength: 0,
                    maxLength: 20,
                    onReset: () {
                      setState(() => user_info!.nickname = null);
                      submit();
                    },
                    onConfirm: (String t) {
                      setState(() => user_info!.nickname = (t.isEmpty ? null : t));
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelContact,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userAddress,
            child: Text(user_info!.address ?? ''),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.address ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.address ?? '',
                    minLength: 0,
                    maxLength: 60,
                    onReset: () {
                      setState(() => user_info!.address = null);
                      submit();
                    },
                    onConfirm: (String t) {
                      setState(() => user_info!.address = (t.isEmpty ? null : t));
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userEmail,
            child: Text(user_info!.email ?? ''),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.email ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.email ?? '',
                    minLength: 0,
                    maxLength: 40,
                    onReset: () {
                      setState(() => user_info!.email = null);
                      submit();
                    },
                    onConfirm: (String t) {
                      setState(() => user_info!.email = (t.isEmpty ? null : t.trim()));
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userPhone,
            child: Text(user_info!.phone ?? ''),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.phone ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.phone ?? '',
                    minLength: 4,
                    maxLength: 20,
                    onReset: () {
                      setState(() => user_info!.phone = null);
                      submit();
                    },
                    onConfirm: (String text) {
                      setState(() => user_info!.phone = text);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelPersonalBackground,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userBirthDate,
            child: Text(user_info!.birth_date?.fmtDate(context) ?? ''),
            actions: [
              IconButton(
                onPressed: () => clipText(formatIsoDate(user_info!.birth_date) ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => DatePicker(
                    initialDate: user_info!.birth_date,
                    onConfirm: (DateTime dt) {
                      setState(() => user_info!.birth_date = dt);
                      submit();
                    },
                    onReset: () {
                      setState(() => user_info!.birth_date = null);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userBirthLocation,
            child: Text(user_info!.birth_location ?? ''),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.birth_location ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.birth_location ?? '',
                    minLength: 2,
                    maxLength: 60,
                    onReset: () {
                      setState(() => user_info!.birth_location = null);
                      submit();
                    },
                    onConfirm: (String t) {
                      setState(() => user_info!.birth_location = (t.isEmpty ? null : t));
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userNationality,
            child: Text(user_info!.nationality ?? ''),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.nationality ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.nationality ?? '',
                    minLength: 2,
                    maxLength: 40,
                    onReset: () {
                      setState(() => user_info!.nationality = null);
                      submit();
                    },
                    onConfirm: (String t) {
                      setState(() => user_info!.nationality = t);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelPhysicalCharacteristics,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userGender,
            child: Text(user_info!.gender?.localizedName(context) ?? ''),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.gender?.localizedName(context) ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => MultiChoiceEdit<Gender>(
                    items: Gender.values,
                    value: user_info!.gender,
                    builder: (gender) => gender.buildTile(context),
                    onReset: () {
                      setState(() => user_info!.gender = null);
                      submit();
                    },
                    onConfirm: (Gender? g) {
                      setState(() => user_info!.gender = g);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userHeight,
            child: Text(user_info!.height != null ? "${user_info!.height} cm" : ''),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.height?.toString() ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.height?.toString() ?? '',
                    minLength: 1,
                    maxLength: 3,
                    onReset: () {
                      setState(() => user_info!.height = null);
                      submit();
                    },
                    onConfirm: (String t) {
                      int? height = int.tryParse(t);
                      if (height == null) {
                        messageText("Failed to parse the input");
                        return;
                      }
                      setState(() => user_info!.height = height);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userWeight,
            child: Text(user_info!.weight != null ? "${user_info!.weight} kg" : ''),
            actions: [
              IconButton(
                onPressed: () => clipText(user_info!.weight?.toString() ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.weight?.toString() ?? '',
                    minLength: 1,
                    maxLength: 3,
                    onReset: () {
                      setState(() => user_info!.weight = null);
                      submit();
                    },
                    onConfirm: (String t) {
                      int? weight = int.tryParse(t);
                      if (weight == null) {
                        messageText("Failed to parse the input");
                        return;
                      }
                      setState(() => user_info!.weight = weight);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          InfoSection(
            title: AppLocalizations.of(context)!.labelMiscellaneous,
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userNote,
            child: Text(user_info!.note ?? ''),
            actions: [
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () => clipText(user_info!.note ?? ''),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TextEditDialog(
                    initialValue: user_info!.note ?? '',
                    minLength: 0,
                    maxLength: 500,
                    onReset: () {
                      setState(() => user_info!.note = null);
                      submit();
                    },
                    onConfirm: (String t) {
                      setState(() => user_info!.note = (t.isEmpty ? null : t));
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userBankacc,
            child: user_info!.bank_account == null
                ? Text(AppLocalizations.of(context)!.labelMissing)
                : user_info!.bank_account!.buildInfo(context),
            actions: [
              if (user_info!.bank_account == null)
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => BankAccountEdit(
                      initialValue: BankAccount.fromVoid(),
                      onConfirm: (BankAccount ba) async {
                        await api_admin.user_bank_account_create(widget.session, user_info!, ba);
                        update();
                      },
                    ),
                  ),
                ),
              if (user_info!.bank_account != null)
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () => clipText(user_info!.bank_account!.clip(context)),
                ),
              if (user_info!.bank_account != null)
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => BankAccountEdit(
                      initialValue: user_info!.bank_account!,
                      onDelete: () async {
                        await api_admin.user_bank_account_delete(widget.session, user_info!);
                        update();
                      },
                      onConfirm: (BankAccount ba) async {
                        await api_admin.user_bank_account_edit(widget.session, user_info!, ba);
                        update();
                      },
                    ),
                  ),
                ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userLicenseMain,
            child: user_info!.license_main == null
                ? ListTile(
                    title: Text(AppLocalizations.of(context)!.labelMissing),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => LicenseEdit(
                          initialValue: License.fromVoid(),
                          onConfirm: (License lic) async {
                            await api_admin.user_license_main_create(widget.session, user_info!, lic);
                            update();
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
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => LicenseEdit(
                              initialValue: user_info!.license_main!,
                              onDelete: () async {
                                await api_admin.user_license_main_delete(widget.session, user_info!);
                                update();
                              },
                              onConfirm: (License lic) async {
                                await api_admin.user_license_main_edit(widget.session, user_info!, lic);
                                update();
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
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => LicenseEdit(
                          initialValue: License.fromVoid(),
                          onConfirm: (License lic) async {
                            await api_admin.user_license_extra_create(widget.session, user_info!, lic);
                            update();
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
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => LicenseEdit(
                              initialValue: user_info!.license_extra!,
                              onDelete: () async {
                                await api_admin.user_license_extra_delete(widget.session, user_info!);
                                update();
                              },
                              onConfirm: (License lic) async {
                                await api_admin.user_license_extra_edit(widget.session, user_info!, lic);
                                update();
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
