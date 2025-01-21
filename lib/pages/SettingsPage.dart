import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/language.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;

  Language? _ctrlLanguage;
  final TextEditingController _ctrlUser = TextEditingController();
  final TextEditingController _ctrlEvent = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      _ctrlLanguage = Language(Locale(_prefs.getString('Language')!));
      _ctrlUser.text = _prefs.getString('UserDefault')!;
      _ctrlEvent.text = _prefs.getString('EventDefault')!;
    });
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
