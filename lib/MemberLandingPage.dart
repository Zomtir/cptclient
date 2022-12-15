import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppIconButton.dart';

import 'static/navigation.dart' as navi;
import 'json/session.dart';

import 'CalendarPage.dart';
import 'MemberProfilePage.dart';
import 'EventOverview.dart';
import 'CourseOverviewPage.dart';

import 'UserOverviewPage.dart';
import 'TeamOverviewPage.dart';
import 'RankingManagement.dart';
import 'EventManagement.dart';

class MemberLandingPage extends StatelessWidget {
  final Session session;

  MemberLandingPage({Key? key, required this.session}) : super(key: key) {
    if (session.user == null) {
      throw new Exception("The member landing page requires a logged-in user.");
    }
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${session.user!.firstname}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => navi.refresh(),
          ),
          IconButton(
            icon: Icon(Icons.perm_identity, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MemberProfilePage(session: session))),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => navi.logout(),
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 5.0,
            spacing: 5.0,
            children: [
              AppIconButton(
                icon: Image.asset('icons/icon_calendar.png'),
                text: "Calendar",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarPage())),
              ),
              AppIconButton(
                icon: Image.asset('icons/icon_course.png'),
                text: "Courses",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseOverviewPage(session: session))),
              ),
              AppIconButton(
                icon: Image.asset('icons/icon_event.png'),
                text: "Events",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventOverview(session: session))),
              ),
              AppIconButton(
                icon: Image.asset('icons/icon_inventory.png'),
                text: "Inventory",
                onPressed: () => {},
              ),
            ],
          ),
          Divider(
            height: 30,
            thickness: 5,
            color: Colors.black,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 5.0,
            spacing: 5.0,
            children: [
              if (session.user!.admin_users) AppIconButton(
                icon: Image.asset('icons/icon_membership.png'),
                text: "Membership\nManagement",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserOverviewPage(session: session))),
              ),
              if (session.user!.admin_users) AppIconButton(
                icon: Image.asset('icons/icon_teams.png'),
                text: "Team\nManagement",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamOverviewPage(session: session))),
              ),
              if (session.user!.admin_rankings) AppIconButton(
                icon: Image.asset('icons/icon_rankings.png'),
                text: "Ranking\nManagement",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RankingManagementPage(session: session))),
              ),
              if (session.user!.admin_reservations) AppIconButton(
                icon: Image.asset('icons/icon_event.png'),
                text: "Event\nManagement",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventManagementPage(session: session))),
              ),
              if (session.user!.admin_courses) AppIconButton(
                icon: Image.asset('icons/icon_course.png'),
                text: "Course\nManagement",
                onPressed: () => {},
              ),
              if (session.user!.admin_inventory) AppIconButton(
                icon: Image.asset('icons/icon_inventory.png'),
                text: "Inventory\nManagement",
                onPressed: () => {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}