import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';

class LoginEventPage extends StatefulWidget {
  LoginEventPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginEventPageState();
}

class LoginEventPageState extends State<LoginEventPage> {
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
      _credentials = navi.eventCredentials;
    });
  }

  void _loginEvent(String login, String passwd, bool remember) async {
    EventSession? session = await server.loginEvent(login, passwd);

    if (remember) {
      navi.addEventCredential(Credential(login, passwd, ''));
    }

    _ctrlLogin.text = "";
    _ctrlPasswd.text = "";
    _ctrlRemember = false;

    if (session == null) return;

    navi.addEventSession(session);
    navi.loginEvent(context, session);
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginEvent),
      ),
      body: AppBody(children: [
        ListTile(
          title: TextFormField(
            maxLines: 1,
            controller: _ctrlLogin,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              labelText: "Event Key",
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
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              labelText: "Event Password",
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
          onPressed: () => _loginEvent(_ctrlLogin.text, _ctrlPasswd.text, _ctrlRemember),
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
      title: Text(credit.login),
      subtitle: Text("Password Length: ${credit.password.length}"),
      onTap: () async {
        setState(() {
          _ctrlLogin.text = credit.login;
          _ctrlPasswd.text = credit.password;
        });
        _loadCredentials();
      },
      trailing: IconButton(
        onPressed: () async {
          navi.removeEventCredential(credit);
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
