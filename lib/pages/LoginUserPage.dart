import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class LoginUserPage extends StatefulWidget {
  LoginUserPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginUserPageState();
}

class LoginUserPageState extends State<LoginUserPage> {
  final TextEditingController _ctrlLogin = TextEditingController();
  final TextEditingController _ctrlPasswd = TextEditingController();
  bool _ctrlRemember = false;
  List<Credential> _credentials = [];

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    setState(() {
      _credentials = navi.userCredentials;
    });
  }

  void _loginUser(String login, String passwd, bool remember) async {
    Result<UserSession> result_session = await server.loginUser(login, passwd);
    if (result_session is! Success) return;

    if (remember) {
      navi.addUserCredential(Credential(login: login, password: passwd, since: DateTime.now()));
    }

    _ctrlLogin.text = "";
    _ctrlPasswd.text = "";
    _ctrlRemember = false;

    var session = result_session.unwrap();
    navi.addUserSession(session);
    navi.loginUser(context, session);
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginUser),
      ),
      body: AppBody(children: [
        ListTile(
          title: TextField(
            maxLines: 1,
            controller: _ctrlLogin,
            autofillHints: const <String>[AutofillHints.username],
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.userKey,
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlLogin.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
          ),
        ),
        ListTile(
          title: TextField(
            obscureText: true,
            maxLines: 1,
            controller: _ctrlPasswd,
            autofillHints: const <String>[AutofillHints.password],
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.userPassword,
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlPasswd.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
          ),
        ),
        ListTile(
          leading: Checkbox(
            value: _ctrlRemember,
            onChanged: (bool? remember) => setState(() => _ctrlRemember = remember!),
          ),
          title: Text(AppLocalizations.of(context)!.actionRemember),
        ),
        AppButton(
          text: AppLocalizations.of(context)!.actionLogin,
          onPressed: () => _loginUser(_ctrlLogin.text, _ctrlPasswd.text, _ctrlRemember),
        ),
        Divider(),
        if (_credentials.isNotEmpty)
          MenuSection(
            title: AppLocalizations.of(context)!.labelLoginsRemembered,
            children: _credentials.map((entry) => buildCredential(entry)).toList(),
          ),
      ]),
    );
  }

  Widget buildCredential(Credential credit) {
    return ListTile(
      title: Text(credit.login!),
      subtitle: Text("${credit.since?.fmtDateTime(context)}"),
      onTap: () => _loginUser(credit.login!, credit.password!, false),
      trailing: IconButton(
        onPressed: () async {
          navi.removeUserCredential(credit);
          _loadCredentials();
        },
        icon: Tooltip(
          child: Icon(Icons.dangerous_outlined),
          message: AppLocalizations.of(context)!.actionDelete,
        ),
      ),
    );
  }
}
