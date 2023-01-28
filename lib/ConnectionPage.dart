import 'package:cptclient/material/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';

import "package:universal_html/html.dart";

import 'static/server.dart' as server;

class ConnectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConnectionPageState();
}

class ConnectionPageState extends State<ConnectionPage> {
  TextEditingController _ctrlServerURL = TextEditingController();
  TextEditingController _ctrlAutoLogin = TextEditingController();
  TextEditingController _ctrlUser = TextEditingController();
  TextEditingController _ctrlSlot = TextEditingController();
  TextEditingController _ctrlLocation = TextEditingController();
  bool _serverOnline = false;

  @override
  void initState() {
    super.initState();

    _ctrlServerURL.text = window.localStorage['ServerURL']!;
    _ctrlAutoLogin.text = window.localStorage['AutoLogin']!;
    _ctrlUser.text = window.localStorage['DefaultUser']!;
    _ctrlSlot.text = window.localStorage['DefaultSlot']!;
    _ctrlLocation.text = window.localStorage['DefaultLocation']!;

    _testConnection();
  }

  void _testConnection() async {
    bool tmpStatus = await server.loadStatus();
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
              onChanged: (String text) { window.localStorage['ServerURL'] = text; server.serverURL = text; },
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
            info: Text("Default User Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUser,
              onChanged: (String text) => { window.localStorage['DefaultUser'] = text },
            ),
          ),
          AppInfoRow(
            info: Text("Default Slot Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlSlot,
              onChanged: (String text) => { window.localStorage['DefaultSlot'] = text },
            ),
          ),
          AppInfoRow(
            info: Text("Default Location Key"),
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
