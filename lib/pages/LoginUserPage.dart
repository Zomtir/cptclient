import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
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
    UserSession? session = await server.loginUser(login, passwd);

    if (remember) {
      navi.addUserCredential(Credential(login: login, password: passwd));
    }

    _ctrlLogin.text = "";
    _ctrlPasswd.text = "";
    _ctrlRemember = false;

    if (session == null) return;
    
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
              labelText: "User Key",
              hintText: "Only alphanumeric characters",
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
              labelText: "Password",
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
          title: Text("Save next login"),
        ),
        AppButton(
          text: "Login",
          onPressed: () => _loginUser(_ctrlLogin.text, _ctrlPasswd.text, _ctrlRemember),
        ),
        Divider(),
        if (_credentials.isNotEmpty)
          MenuSection(
            title: "Saved logins",
            children: _credentials.map((entry) => buildCredential(entry)).toList(),
          ),
      ]),
    );
  }

  Widget buildCredential(Credential credit) {
    return ListTile(
      title: Text(credit.login!),
      subtitle: Text("Password Length: ${credit.password!.length}"),
      onTap: () async {
        setState(() {
          _ctrlLogin.text = credit.login!;
          _ctrlPasswd.text = credit.password!;
        });
        _loadCredentials();
      },
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
