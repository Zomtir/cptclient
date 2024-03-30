import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/pages/ConnectionPage.dart';
import 'package:cptclient/pages/CreditPage.dart';
import 'package:cptclient/pages/LoginCoursePage.dart';
import 'package:cptclient/pages/LoginEventPage.dart';
import 'package:cptclient/pages/LoginLocationPage.dart';
import 'package:cptclient/pages/LoginUserPage.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:universal_html/html.dart" as html;

class LoginLandingPage extends StatefulWidget {
  LoginLandingPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginLandingPageState();
}

class LoginLandingPageState extends State<LoginLandingPage> {
  void _resume() async {
    switch (html.window.localStorage['Session']!) {
      case 'user':
        navi.loginUser();
        break;
      case 'event':
        navi.loginEvent();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: const Image(
                width: 45,
                alignment: Alignment.center,
                image: AssetImage('assets/images/logo_cpt_64.png'),
              ),
            ),
            Text("Course Participation Tracker"),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ConnectionPage())),
          ),
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreditPage())),
          ),
        ],
      ),
      body: AppBody(children: [
        if (html.window.localStorage['Session']!.isNotEmpty)
          AppButton(
            text: AppLocalizations.of(context)!.loginResume,
            onPressed: _resume,
          ),
        if (html.window.localStorage['Session']!.isNotEmpty) Divider(),
        AppButton(
          text: AppLocalizations.of(context)!.loginUser,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginUserPage())),
        ),
        AppButton(
          text: AppLocalizations.of(context)!.loginEvent,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginEventPage())),
        ),
        AppButton(
          text: AppLocalizations.of(context)!.loginCourse,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginCoursePage())),
        ),
        AppButton(
          text: AppLocalizations.of(context)!.loginLocation,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginLocationPage())),
        ),
      ]),
    );
  }
}
