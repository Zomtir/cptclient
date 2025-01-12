import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUserPage extends StatefulWidget {
  LoginUserPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginUserPageState();
}

class LoginUserPageState extends State<LoginUserPage> {
  String _userDefault = '';
  final TextEditingController _ctrlLogin = TextEditingController();
  final TextEditingController _ctrlPasswd = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userDefault = prefs.getString('UserDefault')!;
    _ctrlLogin.text = _userDefault;
  }

  void _loginUser() async {
    UserSession? session = await server.loginUser(_ctrlLogin.text, _ctrlPasswd.text);

    _ctrlLogin.text = _userDefault;
    _ctrlPasswd.text = "";

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
            autofocus: true,
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
        AppButton(
          text: "Login",
          onPressed: _loginUser,
        ),
      ]),
    );
  }
}
