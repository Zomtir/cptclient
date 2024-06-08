import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:universal_html/html.dart" as html;

class ConnectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConnectionPageState();
}

class ConnectionPageState extends State<ConnectionPage> {
  final TextEditingController _ctrlServerScheme = TextEditingController();
  final TextEditingController _ctrlServerHost = TextEditingController();
  final TextEditingController _ctrlServerPort = TextEditingController();
  final TextEditingController _ctrlUser = TextEditingController();
  final TextEditingController _ctrlEvent = TextEditingController();
  final TextEditingController _ctrlCourse = TextEditingController();
  final TextEditingController _ctrlLocation = TextEditingController();
  bool _serverOnline = false;

  @override
  void initState() {
    super.initState();

    _ctrlServerScheme.text = html.window.localStorage['ServerScheme']!;
    _ctrlServerHost.text = html.window.localStorage['ServerHost']!;
    _ctrlServerPort.text = html.window.localStorage['ServerPort']!;
    _ctrlUser.text = html.window.localStorage['DefaultUser']!;
    _ctrlEvent.text = html.window.localStorage['DefaultEvent']!;
    _ctrlCourse.text = html.window.localStorage['DefaultCourse']!;
    _ctrlLocation.text = html.window.localStorage['DefaultLocation']!;

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
        title: Text(AppLocalizations.of(context)!.pageSettings),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: "Language",
            child: Text("EN"),
          ),
          AppInfoRow(
            info: "Server Scheme",
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerScheme,
              onChanged: (String text) {
                html.window.localStorage['ServerScheme'] = text;
                server.serverScheme = text;
              },
            ),
          ),
          AppInfoRow(
            info: "Server Host",
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerHost,
              onChanged: (String text) {
                html.window.localStorage['ServerHost'] = text;
                server.serverHost = text;
              },
            ),
          ),
          AppInfoRow(
            info: "Server Port",
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerPort,
              onChanged: (String text) {
                html.window.localStorage['ServerPort'] = text;
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
            info: "Default User Key",
            child: TextField(
              maxLines: 1,
              controller: _ctrlUser,
              onChanged: (String text) => {html.window.localStorage['DefaultUser'] = text},
            ),
          ),
          AppInfoRow(
            info: "Default Event Key",
            child: TextField(
              maxLines: 1,
              controller: _ctrlEvent,
              onChanged: (String text) => {html.window.localStorage['DefaultEvent'] = text},
            ),
          ),
          AppInfoRow(
            info: "Default Course Key",
            child: TextField(
              maxLines: 1,
              controller: _ctrlCourse,
              onChanged: (String text) => {html.window.localStorage['DefaultCourse'] = text},
            ),
          ),
          AppInfoRow(
            info: "Default Location Key",
            child: TextField(
              maxLines: 1,
              controller: _ctrlLocation,
              onChanged: (String text) => {html.window.localStorage['DefaultLocation'] = text},
            ),
          ),
        ],
      ),
    );
  }
}
