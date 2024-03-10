import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:flutter/material.dart';

class CreditPage extends StatelessWidget {
  final List<(String, String)> authors = [
    ("Moritz Oberhauser", "https://github.com/Zomtir/"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credits"),
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
              subtitle: Text(author.$2, textAlign: TextAlign.center),
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
          subtitle: Text(
            "https://unlicense.org/",
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}
