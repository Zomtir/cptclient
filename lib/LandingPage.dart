import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppButton.dart';

import "package:universal_html/html.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'static/navigation.dart' as navi;
import 'static/crypto.dart' as crypto;
import 'json/credentials.dart';

import 'ConnectionPage.dart';
import 'CreditPage.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {

  TextEditingController _ctrlSlotLogin = TextEditingController();
  TextEditingController _ctrlSlotPasswd = TextEditingController();
  TextEditingController _ctrlUserLogin = TextEditingController();
  TextEditingController _ctrlUserPasswd = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (window.localStorage['Token']! != "") {
      switch(window.localStorage['AutoLogin']!) {
        case 'slot': { navi.confirmSlot(); }
        break;
        case 'autoslot': { _autoSlot(); }
        break;
        case 'user': { navi.confirmUser(); }
        break;
      }
    }
  }

  void _loginSlot() async {
    if (_ctrlSlotLogin.text.isEmpty || _ctrlSlotPasswd.text.isEmpty)
      return;

    Credential credential = Credential(_ctrlSlotLogin.text, _ctrlSlotPasswd.text);
    _ctrlSlotLogin.text = "";
    _ctrlSlotPasswd.text = "";

    var body = json.encode(credential);

    final response = await http.post(
      Uri.http(navi.server, 'slot_login'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
      },
      body: body,
    );

    if (response.statusCode != 200) return;

    window.localStorage['Token'] = response.body;
    navi.confirmSlot();
  }

  void _autoSlot() async {
    if (window.localStorage['DefaultLocation']! == '0')
      return;

    final response = await http.get(
      Uri.http(navi.server, 'slot_autologin', {'location_id': window.localStorage['DefaultLocation']!}),
      headers: {
        'Accept': 'text/plain; charset=utf-8',
      },
    );

    if (response.statusCode != 200) return;

    window.localStorage['Token'] = response.body;
    navi.confirmSlot();
  }

  void _loginUser() async {
    if (_ctrlUserLogin.text.isEmpty || _ctrlUserPasswd.text.isEmpty)
      return;

    Credential credential = Credential(_ctrlUserLogin.text, crypto.hashPassword(_ctrlUserPasswd.text, _ctrlUserLogin.text));
    _ctrlUserLogin.text = "";
    _ctrlUserPasswd.text = "";

    var body = json.encode(credential);

    final response = await http.post(
      Uri.http(navi.server, 'user_login'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
      },
      body: body,
    );

    if (response.statusCode != 200) return;

    window.localStorage['Token'] = response.body;
    navi.confirmUser();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Participation Tracker"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectionPage())),
          ),
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreditPage())),
          ),
        ],
      ),
      body: AppBody(
        children: [
          TextField(
            autofocus: true,
            maxLines: 1,
            controller: _ctrlSlotLogin,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              hintText: "Enter time slot key (8 characters)",
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlSlotLogin.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
          ),
          TextField(
            obscureText: true,
            maxLines: 1,
            controller: _ctrlSlotPasswd,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              hintText: "Enter password",
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlSlotPasswd.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
          ),
          AppButton(
            text: "Time Slot Login",
            onPressed: _loginSlot,
          ),
          Divider(
            height: 30,
            thickness: 5,
            color: Colors.black,
          ),
          TextField(
            maxLines: 1,
            controller: _ctrlUserLogin,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              hintText: "Enter user key (6 characters)",
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlUserLogin.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
          ),
          TextField(
            obscureText: true,
            maxLines: 1,
            controller: _ctrlUserPasswd,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(
              hintText: "Enter password",
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () => _ctrlUserPasswd.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
          ),
          AppButton(
            text: "User Login",
            onPressed: _loginUser,
          ),
        ]
      ),
    );
  }
}

