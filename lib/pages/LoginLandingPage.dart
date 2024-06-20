import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/MenuSection.dart';
import 'package:cptclient/pages/CreditPage.dart';
import 'package:cptclient/pages/LoginCoursePage.dart';
import 'package:cptclient/pages/LoginEventPage.dart';
import 'package:cptclient/pages/LoginLocationPage.dart';
import 'package:cptclient/pages/LoginUserPage.dart';
import 'package:cptclient/pages/SettingsPage.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginLandingPage extends StatefulWidget {
  LoginLandingPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginLandingPageState();
}

class LoginLandingPageState extends State<LoginLandingPage> {
  String userToken = '';
  String eventToken = '';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('UserToken')!;
    eventToken = prefs.getString('EventToken')!;
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
      ),
      body: AppBody(children: [
        if (userToken.isNotEmpty)
          MenuSection(
            title: AppLocalizations.of(context)!.sessionActive,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.sessionResume),
                onTap: () => navi.loginUser(userToken),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.sessionLogout),
                onTap: navi.logoutUser,
              ),
            ],
          ),
        if (eventToken.isNotEmpty)
          MenuSection(
            title: AppLocalizations.of(context)!.sessionActive,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.sessionResume),
                onTap: () => navi.loginUser(eventToken),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.sessionLogout),
                onTap: navi.logoutEvent,
              ),
            ],
          ),
        MenuSection(
          title: AppLocalizations.of(context)!.sessionLogin,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.loginUser),
              leading: Icon(Icons.person),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginUserPage(),
                ),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.loginEvent),
              leading: Icon(Icons.event),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginEventPage(),
                ),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.loginCourse),
              leading: Icon(Icons.sports_soccer),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginCoursePage())),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.loginLocation),
              leading: Icon(Icons.house),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginLocationPage())),
            ),
          ],
        ),
        MenuSection(
          title: AppLocalizations.of(context)!.labelMiscellaneous,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.pageSettings),
              leading: Icon(Icons.settings),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.pageConnection),
              leading: Icon(Icons.link_off),
              onTap: () => navi.gotoRoute('/connect'),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.pageCredits),
              leading: Icon(Icons.info),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreditPage())),
            ),
          ],
        ),
      ]),
    );
  }
}
