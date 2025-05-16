import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/core/router.dart' as router;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/pages/AboutPage.dart';
import 'package:cptclient/pages/LoginCoursePage.dart';
import 'package:cptclient/pages/LoginEventPage.dart';
import 'package:cptclient/pages/LoginLocationPage.dart';
import 'package:cptclient/pages/LoginUserPage.dart';
import 'package:cptclient/pages/SettingsPage.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:flutter/material.dart';

class LoginLandingPage extends StatefulWidget {
  LoginLandingPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginLandingPageState();
}

class LoginLandingPageState extends State<LoginLandingPage> {
  List<UserSession> userSessions = [];
  List<EventSession> eventSessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      userSessions = navi.userSessions;
      eventSessions = navi.eventSessions;
    });
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
        if (userSessions.isNotEmpty)
          MenuSection(
            title: AppLocalizations.of(context)!.sessionActiveUser,
            children: userSessions.map((entry) => buildUserSession(entry)).toList(),
          ),
        if (eventSessions.isNotEmpty)
          MenuSection(
            title: AppLocalizations.of(context)!.sessionActiveEvent,
            children: eventSessions.map((entry) => buildEventSession(entry)).toList(),
          ),
        MenuSection(
          title: AppLocalizations.of(context)!.sessionNew,
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
              onTap: () => router.gotoRoute(context, '/connect'),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.pageAbout),
              leading: Icon(Icons.info),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreditPage())),
            ),
          ],
        ),
      ]),
    );
  }

  Widget buildUserSession(UserSession session) {
    return ListTile(
      title: Text(session.key),
      subtitle: Text(session.expiration.fmtDateTime(context)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () async {
              navi.removeUserSession(session);
              _loadSessions();
            },
            icon: Tooltip(
              child: Icon(Icons.cancel_outlined),
              message: AppLocalizations.of(context)!.actionDelete,
            ),
          ),
          IconButton(
            onPressed: () async {
              bool active = await navi.loginUser(context, session);
              if (!active) navi.removeUserSession(session);
              _loadSessions();
            },
            icon: Tooltip(
              child: Icon(Icons.login),
              message: AppLocalizations.of(context)!.actionResume,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEventSession(EventSession session) {
    return ListTile(
      title: Text(session.key),
      subtitle: Text(session.expiration.fmtDateTime(context)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () async {
              bool active = await navi.loginEvent(context, session);
              if (!active) navi.removeEventSession(session);
              _loadSessions();
            },
            icon: Icon(Icons.login),
          ),
          IconButton(
            onPressed: () async {
              navi.removeEventSession(session);
              _loadSessions();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
