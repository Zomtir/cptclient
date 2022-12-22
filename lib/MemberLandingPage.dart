import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppIconButton.dart';

import 'static/navigation.dart' as navi;
import 'json/session.dart';

import 'CalendarPage.dart';
import 'MemberProfilePage.dart';
import 'EventOverviewPage.dart';
import 'CourseOverviewPage.dart';

import 'UserManagementPage.dart';
import 'TeamManagementPage.dart';
import 'RankingManagementPage.dart';
import 'EventManagement.dart';
import 'CourseManagementPage.dart';

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
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventOverviewPage(session: session))),
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
              if (session.right!.admin_users) AppIconButton(
                icon: Image.asset('icons/icon_membership.png'),
                text: "Membership\nManagement",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementPage(session: session))),
              ),
              if (session.right!.admin_users) AppIconButton(
                icon: Image.asset('icons/icon_teams.png'),
                text: "Team\nManagement",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamManagementPage(session: session))),
              ),
              if (session.right!.admin_rankings) AppIconButton(
                icon: Image.asset('icons/icon_rankings.png'),
                text: "Ranking\nManagement",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RankingManagementPage(session: session))),
              ),
              if (session.right!.admin_event) AppIconButton(
                icon: Image.asset('icons/icon_event.png'),
                text: "Event\nManagement",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventManagementPage(session: session))),
              ),
              if (session.right!.admin_courses) AppIconButton(
                icon: Image.asset('icons/icon_course.png'),
                text: "Course\nManagement",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseManagementPage(session: session))),
              ),
              if (session.right!.admin_inventory) AppIconButton(
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