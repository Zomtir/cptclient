import 'package:cptclient/json/language.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:cptclient/static/server.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionPage extends StatefulWidget {
  ConnectionPage({super.key});

  @override
  State<StatefulWidget> createState() => ConnectionPageState();
}

class ConnectionPageState extends State<ConnectionPage> {
  late SharedPreferences _prefs;

  final TextEditingController _ctrlServerScheme = TextEditingController();
  final TextEditingController _ctrlServerHost = TextEditingController();
  final TextEditingController _ctrlServerPort = TextEditingController();

  Language? _ctrlLanguage;
  final TextEditingController _ctrlUser = TextEditingController();
  final TextEditingController _ctrlEvent = TextEditingController();
  bool _serverOnline = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _ctrlServerScheme.text = _prefs.getString('ServerScheme')!;
    _ctrlServerHost.text = _prefs.getString('ServerHost')!;
    _ctrlServerPort.text = _prefs.getString('ServerPort')!;
    _ctrlLanguage = Language(Locale(_prefs.getString('Language')!));
    _ctrlUser.text = _prefs.getString('UserDefault')!;
    _ctrlEvent.text = _prefs.getString('EventDefault')!;
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
            info: AppLocalizations.of(context)!.labelLanguage,
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
              onChanged: (Language? language) async {
                if (language == null) return;
                await _prefs.setString('Language', language.locale.languageCode);
                navi.applyLocale(context);
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
            info: AppLocalizations.of(context)!.labelServerScheme,
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerScheme,
              onChanged: (String text) {
                _prefs.setString('ServerScheme', text);
                server.serverScheme = text;
              },
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelServerHost,
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerHost,
              onChanged: (String text) {
                _prefs.setString('ServerHost', text);
                server.serverHost = text;
              },
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelServerPort,
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerPort,
              onChanged: (String text) {
                _prefs.setString('ServerPort', text);
                server.serverPort = int.tryParse(text) ?? 443;
              },
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionTest,
            onPressed: _testConnection,
            trailing: Icon(Icons.online_prediction, color: _serverOnline ? Colors.green : Colors.red),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionConnect,
            onPressed: () {
              navi.applyServer();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          AppInfoRow(
            info: "Default User Key",
            child: TextField(
              maxLines: 1,
              controller: _ctrlUser,
              onChanged: (String text) => _prefs.setString('UserDefault', text),
            ),
          ),
          AppInfoRow(
            info: "Default Event Key",
            child: TextField(
              maxLines: 1,
              controller: _ctrlEvent,
              onChanged: (String text) => _prefs.setString('EventDefault', text),
            ),
          ),
        ],
      ),
    );
  }
}
