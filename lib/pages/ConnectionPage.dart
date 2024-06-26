import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/MenuSection.dart';
import 'package:cptclient/pages/CreditPage.dart';
import 'package:cptclient/pages/SettingsPage.dart';
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

    _updateServerScheme(_ctrlServerScheme.text);
    _updateServerHost(_ctrlServerHost.text);
    _updateServerPort(_ctrlServerPort.text);
    _testConnection();
  }

  _updateServerScheme(String text) {
    _prefs.setString('ServerScheme', text);
    server.serverScheme = text;
  }

  _updateServerHost(String text) {
    _prefs.setString('ServerHost', text);
    server.serverHost = text;
  }

  _updateServerPort(String text) {
    _prefs.setString('ServerPort', text);
    server.serverPort = int.tryParse(text) ?? 443;
  }

  void _testConnection() async {
    bool tmpStatus = await server.loadStatus();
    setState(() => _serverOnline = tmpStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageConnection),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelServerScheme,
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerScheme,
              onChanged: _updateServerScheme,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelServerHost,
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerHost,
              onChanged: _updateServerHost,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelServerPort,
            child: TextField(
              maxLines: 1,
              controller: _ctrlServerPort,
              onChanged: _updateServerPort,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionTest,
            onPressed: _testConnection,
            leading: Icon(Icons.online_prediction, color: _serverOnline ? Colors.green : Colors.red),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionConnect,
            onPressed: () {
              navi.applyServer();
              navi.gotoRoute('/login');
            },
            leading: Icon(Icons.link),
          ),
          MenuSection(
            title: AppLocalizations.of(context)!.labelMiscellaneous,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageSettings),
                leading: Icon(Icons.settings),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCredits),
                leading: Icon(Icons.info),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreditPage())),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
