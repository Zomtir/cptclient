import 'package:cptclient/json/language.dart';
import 'package:cptclient/main.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:universal_html/html.dart" as html;

class ConnectionPage extends StatefulWidget {
  ConnectionPage({super.key});

  @override
  State<StatefulWidget> createState() => ConnectionPageState();
}

class ConnectionPageState extends State<ConnectionPage> {
  Language _ctrlLanguage = Language(Locale(html.window.localStorage['Language']!));
  final TextEditingController _ctrlServerScheme =
      TextEditingController(text: html.window.localStorage['ServerScheme']!);
  final TextEditingController _ctrlServerHost = TextEditingController(text: html.window.localStorage['ServerHost']!);
  final TextEditingController _ctrlServerPort = TextEditingController(text: html.window.localStorage['ServerPort']!);
  final TextEditingController _ctrlUser = TextEditingController(text: html.window.localStorage['DefaultUser']!);
  final TextEditingController _ctrlEvent = TextEditingController(text: html.window.localStorage['DefaultEvent']!);
  final TextEditingController _ctrlCourse = TextEditingController(text: html.window.localStorage['DefaultCourse']!);
  final TextEditingController _ctrlLocation = TextEditingController(text: html.window.localStorage['DefaultLocation']!);
  bool _serverOnline = false;

  @override
  void initState() {
    super.initState();
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
            child: DropdownButton<Language>(
              value: _ctrlLanguage,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.grey),
              isExpanded: true,
              underline: Container(
                height: 2,
                color: Colors.grey,
              ),
              onChanged: (Language? language) {
                if (language == null) return;
                context.findAncestorStateOfType<CptState>()!.changeLocale(language.locale);
                setState(() => _ctrlLanguage = language);
              },
              items: Language.entries.map<DropdownMenuItem<Language>>((Language l) {
                return DropdownMenuItem<Language>(
                  value: l,
                  child: Text(l.localizedName(context)),
                );
              }).toList(),
              //selectedItemBuilder,
            ),
          ),
          Divider(),
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
