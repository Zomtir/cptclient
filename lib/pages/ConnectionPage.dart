import 'package:cptclient/api/login.dart' as api;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/core/router.dart' as router;
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/AboutPage.dart';
import 'package:cptclient/pages/SettingsPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';
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

  final TextEditingController _ctrlClientScheme = TextEditingController();
  final TextEditingController _ctrlClientHost = TextEditingController();
  final TextEditingController _ctrlClientPort = TextEditingController();

  bool _serverOnline = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _ctrlServerScheme.text = _prefs.getString('ServerScheme')!;
    _ctrlServerHost.text = _prefs.getString('ServerHost')!;
    _ctrlServerPort.text = _prefs.getInt('ServerPort')!.toString();

    _updateServerScheme(_ctrlServerScheme.text);
    _updateServerHost(_ctrlServerHost.text);
    _updateServerPort(_ctrlServerPort.text);

    _ctrlClientScheme.text = _prefs.getString('ClientScheme')!;
    _ctrlClientHost.text = _prefs.getString('ClientHost')!;
    _ctrlClientPort.text = _prefs.getInt('ClientPort')!.toString();

    _updateClientScheme(_ctrlClientScheme.text);
    _updateClientHost(_ctrlClientHost.text);
    _updateClientPort(_ctrlClientPort.text);

    _testConnection();
  }

  void _updateServerScheme(String text) {
    _prefs.setString('ServerScheme', text);
    navi.applyServer();
  }

  void _updateServerHost(String text) {
    _prefs.setString('ServerHost', text);
    navi.applyServer();
  }

  void _updateServerPort(String text) {
    var port = int.tryParse(text) ?? 443;
    _prefs.setInt('ServerPort', port);
    navi.applyServer();
  }

  void _updateClientScheme(String text) {
    _prefs.setString('ClientScheme', text);
  }

  void _updateClientHost(String text) {
    _prefs.setString('ClientHost', text);
  }

  void _updateClientPort(String text) {
    var port = int.tryParse(text) ?? 443;
    _prefs.setInt('ClientPort', port);
  }

  void _testConnection() async {
    var result = await api.loadStatus();
    setState(() => _serverOnline = (result is Success));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageConnection),
      ),
      body: AppBody(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.labelServer),
          ),
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
              router.gotoRoute(context, '/login');
            },
            leading: Icon(Icons.link),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.labelClient),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelClientScheme,
            child: TextField(
              maxLines: 1,
              controller: _ctrlClientScheme,
              onChanged: _updateClientScheme,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelClientHost,
            child: TextField(
              maxLines: 1,
              controller: _ctrlClientHost,
              onChanged: _updateClientHost,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelClientPort,
            child: TextField(
              maxLines: 1,
              controller: _ctrlClientPort,
              onChanged: _updateClientPort,
            ),
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
                title: Text(AppLocalizations.of(context)!.pageAbout),
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
