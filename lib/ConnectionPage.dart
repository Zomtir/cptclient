import 'package:cptclient/material/app/AppButton.dart';
import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppInfoRow.dart';

import "package:universal_html/html.dart";

import 'static/navigation.dart' as navi;

class ConnectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConnectionPageState();
}

class ConnectionPageState extends State<ConnectionPage> {
  TextEditingController _ctrlServerURL = TextEditingController();
  TextEditingController _ctrlAutoLogin = TextEditingController();
  TextEditingController _ctrlLocation = TextEditingController();
  bool _serverOnline = false;

  @override
  void initState() {
    super.initState();

    _ctrlServerURL.text = window.localStorage['ServerURL']!;
    _ctrlAutoLogin.text = window.localStorage['AutoLogin']!;
    _ctrlLocation.text = window.localStorage['DefaultLocation']!;

    _testConnection();
  }

  void _testConnection() async {
    window.localStorage.putIfAbsent('ServerURL', ()=>'localhost:8002');
    window.localStorage.putIfAbsent('Token', ()=>'');
    window.localStorage.putIfAbsent('AutoLogin', ()=>'none');
    window.localStorage.putIfAbsent('DefaultLocation', ()=>'0');

    bool tmpStatus = await navi.loadStatus();
    setState(() => _serverOnline = tmpStatus);
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: Text("Language"),
            child: Text("EN"),
          ),
          AppInfoRow(
            info: Wrap(
              spacing: 15,
              children: [
              Text("Server"),
              Icon(Icons.online_prediction, color: _serverOnline ? Colors.green : Colors.red),
            ],),
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerURL,
              onChanged: (String text) { window.localStorage['ServerURL'] = text; navi.serverURL = text; },
            ),
            trailing:
              IconButton(
                onPressed: _testConnection,
                icon: Icon(Icons.refresh),
              ),
          ),
          AppInfoRow(
            info: Text("Auto Login"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlAutoLogin,
              onChanged: (String text) => { window.localStorage['AutoLogin'] = text },
            ),
          ),
          AppInfoRow(
            info: Text("Default Location ID"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlLocation,
              onChanged: (String text) => { window.localStorage['DefaultLocation'] = text },
            ),
          ),
          AppButton(
            text: "Reconnect",
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
