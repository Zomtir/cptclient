import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
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
  final ScreenshotController _ctrlSceenshot = ScreenshotController();

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
    String key = widget.credits.login!;
    String pwd = widget.credits.password!;

    setState(() => url = "$scheme://$host:$port/#/login_event?key=$key&pwd=$pwd");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventDetails),
      ),
      body: AppBody(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Screenshot(
                controller: _ctrlSceenshot,
                child: QrImageView(
                  data: url,
                  version: QrVersions.auto,
                  size: 256.0,
                  gapless: false,
                ),
              ),
              IconButton(onPressed: () async {
                String fileName = "CPT_QR_event_${widget.event.id}";
                Uint8List? image;
                await _ctrlSceenshot.capture().then((capturedImage) => image = capturedImage);
                exportPNG(fileName, image!);
              }, icon: Icon(Icons.screenshot)),
            ],
          ),
          ListTile(
            dense: true,
            title: Text(url),
            trailing: IconButton(
              icon: Icon(Icons.copy_rounded),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: url)).then((_) {
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
