import 'package:cptclient/core/client.dart' as client;
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CreditPage extends StatelessWidget {
  final List<(String, String)> authors = [
    ("Moritz Oberhauser", "https://github.com/Zomtir/"),
    ("August Oberhauser", "https://github.com/Gustl22/"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageAbout),
      ),
      body: AppBody(children: <Widget>[
        Text(
          AppLocalizations.of(context)!.labelRelease,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListTile(
          leading: const Image(
            width: 56,
            height: 56,
            image: AssetImage('assets/images/logo_cpt_256.png'),
          ),
          title: Text("${AppLocalizations.of(context)!.labelVersion} ${client.version}"),
        ),
        Text(
          AppLocalizations.of(context)!.labelLicense,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListTile(
          leading: const Image(
            width: 56,
            height: 56,
            image: AssetImage('assets/images/logo_public_domain.png'),
          ),
          title: Text(
            "Public Domain",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: InkWell(
            child: Text(
              "https://unlicense.org/",
            ),
            onTap: () => launchUrlString("https://unlicense.org/"),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.labelAuthors,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppListView(
          items: authors,
          itemBuilder: (author) {
            return ListTile(
              leading: const Icon(Icons.brush, size: 56),
              title: Text(author.$1),
              subtitle: InkWell(
                child: Text(author.$2),
                onTap: () => launchUrlString(author.$2),
              ),
            );
          },
        ),
      ]),
    );
  }
}
