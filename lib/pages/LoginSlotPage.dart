import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:cptclient/static/server.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:universal_html/html.dart" as html;

class LoginSlotPage extends StatefulWidget {
  LoginSlotPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginSlotPageState();
}

class LoginSlotPageState extends State<LoginSlotPage> {
  final TextEditingController _ctrlSlotLogin = TextEditingController();
  final TextEditingController _ctrlSlotPasswd = TextEditingController();

  @override
  void initState() {
    super.initState();

    _ctrlSlotLogin.text = html.window.localStorage['DefaultSlot']!;
  }

  void _loginSlot() async {
    bool success = await server.loginSlot(_ctrlSlotLogin.text, _ctrlSlotPasswd.text);

    _ctrlSlotLogin.text = html.window.localStorage['DefaultSlot']!;
    _ctrlSlotPasswd.text = "";

    if (success) navi.loginSlot();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginSlot),
      ),
      body: AppBody(children: [
        ListTile(
          title: TextFormField(
            maxLines: 1,
            controller: _ctrlSlotLogin,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              labelText: "Slot Key",
              hintText: "8 alphanumeric characters",
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlSlotLogin.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
          ),
        ),
        ListTile(
          title: TextField(
            obscureText: true,
            maxLines: 1,
            controller: _ctrlSlotPasswd,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              labelText: "Slot Password",
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlSlotPasswd.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
          ),
        ),
        AppButton(
          text: "Login",
          onPressed: _loginSlot,
        ),
        Divider(),
      ]),
    );
  }
}
