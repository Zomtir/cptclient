import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventExportPage extends StatefulWidget {
  final UserSession session;
  final Event event;
  final Credential credits;

  EventExportPage({
    super.key,
    required this.session,
    required this.event,
    required this.credits,
  });

  @override
  EventExportPageState createState() => EventExportPageState();
}

class EventExportPageState extends State<EventExportPage> {
  String url = "";
  EventExportPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  _update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String scheme = prefs.getString('ClientScheme')!;
    String host = prefs.getString('ClientHost')!;
    int port = prefs.getInt('ClientPort')!;
    String key = widget.credits.login;
    String pwd = widget.credits.password;

    setState(() => url = "$scheme://$host:$port/#/login_event?key=$key&pwd=$pwd");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventEdit),
      ),
      body: AppBody(
        children: [
          Center(
            child: QrImageView(
              data: url,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(url),
            trailing: IconButton(
              icon: Icon(Icons.copy_rounded),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: url)).then((_){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("URL copied to clipboard")));
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
