import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CreditPage extends StatelessWidget {
  final List<(String, String)> authors = [
    ("Moritz Oberhauser", "https://github.com/Zomtir/"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCredits),
      ),
      body: AppBody(children: <Widget>[
        Text(
          "Authors",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Image(
          width: 128,
          height: 128,
          alignment: Alignment.topCenter,
          image: AssetImage('assets/images/logo_cpt_256.png'),
        ),
        AppListView(
          items: authors,
          itemBuilder: (author) {
            return ListTile(
              title: Text(author.$1, textAlign: TextAlign.center),
              subtitle: InkWell(
                child: Text(author.$2, textAlign: TextAlign.center),
                onTap: () => launchUrlString(author.$2),
              ),
            );
          },
        ),
        Text(
          "License",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Image(
          width: 128,
          height: 128,
          alignment: Alignment.center,
          image: AssetImage('assets/images/logo_public_domain.png'),
        ),
        ListTile(
          title: Text(
            "Public Domain",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: InkWell(
            child: Text(
              "https://unlicense.org/",
              textAlign: TextAlign.center,
            ),
            onTap: () => launchUrlString("https://unlicense.org/"),
          ),
        ),
      ]),
    );
  }
}
