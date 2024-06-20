import 'package:cptclient/json/location.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_location_anon.dart' as api_anon;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    List<Location> locations = await api_anon.location_list();

    setState(() {
      _locations = locations;
    });
  }

  void _loginLocation() async {
    String? token = await server.loginLocation(_ctrlLogin.text);
    if (token != null) navi.loginEvent(token);
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
            labelText: "Location Key",
            hintText: "Only alphanumeric characters",
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
          text: "Login",
          onPressed: _loginLocation,
        ),
      ]),
    );
  }
}
