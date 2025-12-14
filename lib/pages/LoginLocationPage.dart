import 'package:cptclient/api/anon/location.dart' as api_anon;
import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class LoginLocationPage extends StatefulWidget {
  LoginLocationPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginLocationPageState();
}

class LoginLocationPageState extends State<LoginLocationPage> {
  final TextEditingController _ctrlLogin = TextEditingController();
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    _receiveLocations();
  }

  Future<void> _receiveLocations() async {
    Result<List<Location>> result_locations = await api_anon.location_list();
    if (result_locations is! Success) return;

    setState(() {
      _locations = result_locations.unwrap();
    });
  }

  void _loginLocation() async {
    Result<EventSession> result_session = await server.loginLocation(_ctrlLogin.text);
    if (result_session is! Success) return;
    var session = result_session.unwrap();
    navi.addEventSession(session);
    navi.loginEvent(context, session);
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginLocation),
      ),
      body: AppBody(children: [
        TextFormField(
          autofocus: true,
          maxLines: 1,
          controller: _ctrlLogin,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.locationKey,
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () => _ctrlLogin.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        AppListView(
          items: _locations,
          itemBuilder: (location) => ListTile(
            title: Text(location.name),
            onTap: () => _ctrlLogin.text = location.key,
          ),
        ),
        AppButton(
          text: AppLocalizations.of(context)!.actionLogin,
          onPressed: _loginLocation,
        ),
      ]),
    );
  }
}
