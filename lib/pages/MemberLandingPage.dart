import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppIconButton.dart';
import 'package:cptclient/material/AppModuleSection.dart';
import 'package:cptclient/pages/CalendarMonthPage.dart';
import 'package:cptclient/pages/ClubOverviewPage.dart';
import 'package:cptclient/pages/CompetenceOverviewManagementPage.dart';
import 'package:cptclient/pages/CompetenceSummaryPage.dart';
import 'package:cptclient/pages/CourseAvailablePage.dart';
import 'package:cptclient/pages/CourseManagementPage.dart';
import 'package:cptclient/pages/CourseResponsiblePage.dart';
import 'package:cptclient/pages/EventOverviewAvailablePage.dart';
import 'package:cptclient/pages/EventOverviewManagementPage.dart';
import 'package:cptclient/pages/EventOverviewOwnershipPage.dart';
import 'package:cptclient/pages/LocationOverviewPage.dart';
import 'package:cptclient/pages/MemberProfilePage.dart';
import 'package:cptclient/pages/SkillOverviewPage.dart';
import 'package:cptclient/pages/TeamOverviewManagementPage.dart';
import 'package:cptclient/pages/TermManagementPage.dart';
import 'package:cptclient/pages/UserOverviewPage.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MemberLandingPage extends StatelessWidget {
  final Session session;

  MemberLandingPage({super.key, required this.session}) {
    if (session.user == null) {
      throw Exception("The member landing page requires a logged-in user.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${session.user!.firstname}"),
        actions: <Widget>[
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
          AppIconButton(
            image: const AssetImage('assets/icons/icon_calendar.png'),
            text: AppLocalizations.of(context)!.labelCalendar,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarMonthPage(session: session,))),
          ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_inventory.png'),
            text: AppLocalizations.of(context)!.labelInventory,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageInventoryPersonal,
            onPressed: () => {},
          ),
          if (session.right!.inventory.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageInventoryManagement,
              onPressed: () => {},
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_course.png'),
            text: AppLocalizations.of(context)!.labelCourse,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseAvailable,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseAvailablePage(session: session))),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseResponsible,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseResponsiblePage(session: session))),
          ),
          if (session.right!.course.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageCourseManagement,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseManagementPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_event.png'),
            text: AppLocalizations.of(context)!.labelEvent,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventAvailable,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventOverviewAvailablePage(session: session))),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventOwnership,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventOverviewOwnershipPage(session: session))),
          ),
          if (session.right!.event.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageEventManagement,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventOverviewManagementPage(session: session))),
            ),
          if (session.right!.location.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageLocationManagement,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LocationOverviewPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_rankings.png'),
            text: AppLocalizations.of(context)!.labelRanking,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageRankingPersonal,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CompetenceSummaryPage(session: session))),
          ),
          if (session.right!.competence.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageRankingManagement,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CompetenceOverviewManagementPage(session: session))),
            ),
          if (session.right!.competence.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageSkillManagement,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SkillOverviewPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_teams.png'),
            text: AppLocalizations.of(context)!.labelTeam,
          ),
          if (session.right!.team.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageTeamManagement,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamOverviewManagementPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_membership.png'),
            text: AppLocalizations.of(context)!.labelTerm,
          ),
          if (session.right!.club.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageClubManagement,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClubOverviewPage(session: session))),
            ),
          if (session.right!.club.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageTermManagement,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TermManagementPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_user.png'),
            text: AppLocalizations.of(context)!.labelUser,
          ),
          if (session.right!.user.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageUserManagement,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserOverviewPage(session: session))),
            ),
        ],
      ),
    );
  }
}
