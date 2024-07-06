import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/static/navigation.dart' as navi;
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
  final TextEditingController _ctrlUserLogin = TextEditingController();
  final TextEditingController _ctrlUserPasswd = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userDefault = prefs.getString('UserDefault')!;
    _ctrlUserLogin.text = _userDefault;
  }

  void _loginUser() async {
    String? token = await server.loginUser(_ctrlUserLogin.text, _ctrlUserPasswd.text);

    _ctrlUserLogin.text = _userDefault;
    _ctrlUserPasswd.text = "";

    if (token != null) navi.loginUser(context, token);
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
            controller: _ctrlUserLogin,
            autofillHints: const <String>[AutofillHints.username],
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              labelText: "User Key",
              hintText: "Only alphanumeric characters",
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlUserLogin.clear(),
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
            controller: _ctrlUserPasswd,
            autofillHints: const <String>[AutofillHints.password],
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              labelText: "Password",
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlUserPasswd.clear(),
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
