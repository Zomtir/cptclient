import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class UserCreatePage extends StatefulWidget {
  final UserSession session;
  final User? user;

  UserCreatePage({super.key, required this.session, this.user});

  @override
  UserCreatePageState createState() => UserCreatePageState();
}

class UserCreatePageState extends State<UserCreatePage> {
  bool _ctrlActive = true;
  final TextEditingController _ctrlFirstname = TextEditingController();
  final TextEditingController _ctrlLastname = TextEditingController();
  final TextEditingController _ctrlNickname = TextEditingController();
  final TextEditingController _ctrlNote = TextEditingController();

  UserCreatePageState();

  @override
  void initState() {
    super.initState();

    User user = widget.user ?? User.fromVoid();
    _ctrlActive = user.active ?? false;
    _ctrlFirstname.text = user.firstname;
    _ctrlLastname.text = user.lastname;
    _ctrlNickname.text = user.nickname ?? '';
    _ctrlNote.text = user.note ?? '';
  }

  void _submit() async {
    if (_ctrlFirstname.text.isEmpty || _ctrlFirstname.text.length > 20) {
      messageText("${AppLocalizations.of(context)!.userFirstname} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (_ctrlLastname.text.isEmpty || _ctrlLastname.text.length > 20) {
      messageText("${AppLocalizations.of(context)!.userLastname} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (_ctrlNickname.text.length > 20) {
      messageText("${AppLocalizations.of(context)!.userNickname} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    User user = User.fromVoid();
    user.active = _ctrlActive;
    user.firstname = _ctrlFirstname.text;
    user.lastname = _ctrlLastname.text;
    user.nickname = _ctrlNickname.text.isNotEmpty ? _ctrlNickname.text : null;
    user.note = _ctrlNote.text.isNotEmpty ? _ctrlNote.text : null;

    var result = await api_admin.user_create(widget.session, user);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageUserCreate),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.userActive,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Checkbox(
                value: _ctrlActive,
                onChanged: (bool? active) => setState(() => _ctrlActive = active!),
              ),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userFirstname} *",
            child: TextField(
              maxLines: 1,
              controller: _ctrlFirstname,
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.userLastname} *",
            child: TextField(
              maxLines: 1,
              controller: _ctrlLastname,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userNickname,
            child: TextField(
              maxLines: 1,
              controller: _ctrlNickname,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userNote,
            child: TextField(
              maxLines: 8,
              controller: _ctrlNote,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
