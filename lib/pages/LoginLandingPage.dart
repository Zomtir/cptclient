import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/pages/ConnectionPage.dart';
import 'package:cptclient/pages/CreditPage.dart';
import 'package:cptclient/pages/LoginCoursePage.dart';
import 'package:cptclient/pages/LoginLocationPage.dart';
import 'package:cptclient/pages/LoginSlotPage.dart';
import 'package:cptclient/pages/LoginUserPage.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:flutter/material.dart';
import 'dart:html';

class LoginLandingPage extends StatefulWidget {
  LoginLandingPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginLandingPageState();
}

class LoginLandingPageState extends State<LoginLandingPage> {

  @override
  void initState() {
    super.initState();
  }

  void _resume() async {
    switch (window.localStorage['Session']!) {
      case 'user':
        navi.loginUser();
        break;
      case 'slot':
        navi.loginSlot();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Participation Tracker"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectionPage())),
          ),
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreditPage())),
          ),
        ],
      ),
      body: AppBody(children: [
        if (window.localStorage['Session']!.isNotEmpty) AppButton(
          text: "Resume Session",
          onPressed: _resume,
        ),
        if (window.localStorage['Session']!.isNotEmpty) Divider(),
        AppButton(
          text: "User Login",
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginUserPage())),
        ),
        AppButton(
          text: "Slot Login",
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginSlotPage())),
        ),
        AppButton(
          text: "Course Login",
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginCoursePage())),
        ),
        AppButton(
          text: "Location Login",
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginLocationPage())),
        ),
      ]),
    );
  }
}
