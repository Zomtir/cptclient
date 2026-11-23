import 'package:cptclient/api/login.dart' as api;
import 'package:cptclient/api/user/salt.dart' as api;
import 'package:cptclient/api/user/user.dart' as api;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/widgets/AppBody.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/MenuSection.dart';
import 'package:cptclient/utils/crypto.dart' as crypto;
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

  void _loginUser(String key, String pwd, bool remember) async {
    if (key.isEmpty || pwd.isEmpty) return;

    Result<String> result_salt = await api.user_salt(key);
    if (result_salt is! Success) return;
    var salt = result_salt.unwrap();

    Credential credential = Credential(login: key, password: crypto.hashPassword(pwd, salt), salt: salt);

    Result<(int, String)> result_id_token = await api.loginUser(key, credential);
    if (result_id_token is! Success) return;
    var (id, token) = result_id_token.unwrap();

    var uSession = UserSession(key,token,DateTime.now().add(Duration(hours: 3)));

    Result<User> result_user = await api.user_info(uSession, id);
    if (result_user is! Success) return;
    uSession.user = result_user.unwrap();

    Result<Right> result_right = await api.right_info(uSession, id);
    if (result_right is! Success) return;
    uSession.right = result_right.unwrap();

    _ctrlLogin.text = "";
    _ctrlPasswd.text = "";
    _ctrlRemember = false;

    if (remember) {
      navi.addUserCredential(Credential(login: key, password: pwd, since: DateTime.now()));
    }

    navi.addUserSession(uSession);
    navi.useUserSession(context, uSession);
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginUser),
      ),
      body: AppBody(
        builder: (context) => [
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
        ],
      ),
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
