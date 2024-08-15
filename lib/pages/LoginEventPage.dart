import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginEventPage extends StatefulWidget {
  LoginEventPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginEventPageState();
}

class LoginEventPageState extends State<LoginEventPage> {
  String _eventDefault = '';
  final TextEditingController _ctrlLogin = TextEditingController();
  final TextEditingController _ctrlPasswd = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _eventDefault = prefs.getString('EventDefault')!;
    _ctrlLogin.text = _eventDefault;
  }

  void _loginEvent() async {
    String? token = await server.loginEvent(_ctrlLogin.text, _ctrlPasswd.text);

    _ctrlLogin.text = _eventDefault;
    _ctrlPasswd.text = "";

    if (token != null) navi.loginEvent(context, token);
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
