import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:cptclient/static/server.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:universal_html/html.dart" as html;

class LoginEventPage extends StatefulWidget {
  LoginEventPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginEventPageState();
}

class LoginEventPageState extends State<LoginEventPage> {
  final TextEditingController _ctrlLogin = TextEditingController();
  final TextEditingController _ctrlPasswd = TextEditingController();

  @override
  void initState() {
    super.initState();

    _ctrlLogin.text = html.window.localStorage['DefaultEvent']!;
  }

  void _loginEvent() async {
    bool success = await server.loginEvent(_ctrlLogin.text, _ctrlPasswd.text);

    _ctrlLogin.text = html.window.localStorage['DefaultEvent']!;
    _ctrlPasswd.text = "";

    if (success) navi.loginEvent();
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
        AppButton(
          text: "Login",
          onPressed: _loginEvent,
        ),
        Divider(),
      ]),
    );
  }
}
