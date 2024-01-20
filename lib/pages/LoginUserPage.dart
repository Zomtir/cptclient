import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:cptclient/static/server.dart' as server;
import 'package:flutter/material.dart';
import "package:universal_html/html.dart" as html;

class LoginUserPage extends StatefulWidget {
  LoginUserPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginUserPageState();
}

class LoginUserPageState extends State<LoginUserPage> {
  final TextEditingController _ctrlUserLogin = TextEditingController();
  final TextEditingController _ctrlUserPasswd = TextEditingController();

  @override
  void initState() {
    super.initState();

    _ctrlUserLogin.text = html.window.localStorage['DefaultUser']!;
  }
  void _loginUser() async {
    bool success = await server.loginUser(_ctrlUserLogin.text, _ctrlUserPasswd.text);

    _ctrlUserLogin.text = html.window.localStorage['DefaultUser']!;
    _ctrlUserPasswd.text = "";

    if (success) navi.loginUser();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Login"),
      ),
      body: AppBody(children: [
        TextField(
          maxLines: 1,
          controller: _ctrlUserLogin,
          autofillHints: const <String>[AutofillHints.username],
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: "User Key",
            hintText: "6 alphanumeric characters",
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () => _ctrlUserLogin.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        TextField(
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
        AppButton(
          text: "Login",
          onPressed: _loginUser,
        ),
      ]),
    );
  }
}
