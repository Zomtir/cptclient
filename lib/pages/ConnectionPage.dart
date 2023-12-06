import 'package:flutter/material.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';

import "package:universal_html/html.dart";

import '../static/server.dart' as server;

class ConnectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConnectionPageState();
}

class ConnectionPageState extends State<ConnectionPage> {
  TextEditingController _ctrlServerScheme = TextEditingController();
  TextEditingController _ctrlServerHost = TextEditingController();
  TextEditingController _ctrlServerPort = TextEditingController();
  TextEditingController _ctrlUser = TextEditingController();
  TextEditingController _ctrlSlot = TextEditingController();
  TextEditingController _ctrlCourse = TextEditingController();
  TextEditingController _ctrlLocation = TextEditingController();
  bool _serverOnline = false;

  @override
  void initState() {
    super.initState();

    _ctrlServerScheme.text = window.localStorage['ServerScheme']!;
    _ctrlServerHost.text = window.localStorage['ServerHost']!;
    _ctrlServerPort.text = window.localStorage['ServerPort']!;
    _ctrlUser.text = window.localStorage['DefaultUser']!;
    _ctrlSlot.text = window.localStorage['DefaultSlot']!;
    _ctrlCourse.text = window.localStorage['DefaultCourse']!;
    _ctrlLocation.text = window.localStorage['DefaultLocation']!;

    _testConnection();
  }

  void _testConnection() async {
    bool tmpStatus = await server.loadStatus();
    setState(() => _serverOnline = tmpStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            info: Text("Server Scheme"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerScheme,
              onChanged: (String text) {
                window.localStorage['ServerScheme'] = text;
                server.serverScheme = text;
              },
            ),
          ),
          AppInfoRow(
            info: Text("Server Host"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerHost,
              onChanged: (String text) {
                window.localStorage['ServerHost'] = text;
                server.serverHost = text;
              },
            ),
          ),
          AppInfoRow(
            info: Text("Server Port"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerPort,
              onChanged: (String text) {
                window.localStorage['ServerPort'] = text;
                server.serverPort = int.tryParse(text) ?? 443;
              },
            ),
          ),
          AppButton(
            text: "Test",
            onPressed: _testConnection,
            trailing: Icon(Icons.online_prediction, color: _serverOnline ? Colors.green : Colors.red),
          ),
          AppButton(
            text: "Reconnect",
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          AppInfoRow(
            info: Text("Default User Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlUser,
              onChanged: (String text) => {window.localStorage['DefaultUser'] = text},
            ),
          ),
          AppInfoRow(
            info: Text("Default Slot Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlSlot,
              onChanged: (String text) => {window.localStorage['DefaultSlot'] = text},
            ),
          ),
          AppInfoRow(
            info: Text("Default Course Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlCourse,
              onChanged: (String text) => {window.localStorage['DefaultCourse'] = text},
            ),
          ),
          AppInfoRow(
            info: Text("Default Location Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlLocation,
              onChanged: (String text) => {window.localStorage['DefaultLocation'] = text},
            ),
          ),
        ],
      ),
    );
  }
}
