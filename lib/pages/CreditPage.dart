import 'package:cptclient/material/AppBody.dart';
import 'package:flutter/material.dart';

class CreditPage extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credits"),
      ),
      body: AppBody(
          children: <Widget>[
            Text("Authors:\n - Moritz Oberhauser"),
            Text("License:\n - CC0 (Public Domain)"),
          ]
      ),
    );
  }
}
