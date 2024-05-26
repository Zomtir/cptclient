import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppIconButton.dart';
import 'package:cptclient/material/AppModuleSection.dart';
import 'package:cptclient/pages/CalendarMonthPage.dart';
import 'package:cptclient/pages/ClubOverviewPage.dart';
import 'package:cptclient/pages/CompetenceOverviewPage.dart';
import 'package:cptclient/pages/CompetenceSummaryPage.dart';
import 'package:cptclient/pages/CourseAvailablePage.dart';
import 'package:cptclient/pages/CourseManagementPage.dart';
import 'package:cptclient/pages/CourseResponsiblePage.dart';
import 'package:cptclient/pages/EventOverviewAvailablePage.dart';
import 'package:cptclient/pages/EventOverviewManagementPage.dart';
import 'package:cptclient/pages/EventOverviewOwnershipPage.dart';
import 'package:cptclient/pages/ItemOverviewPage.dart';
import 'package:cptclient/pages/ItemcatOverviewPage.dart';
import 'package:cptclient/pages/LocationOverviewPage.dart';
import 'package:cptclient/pages/MemberProfilePage.dart';
import 'package:cptclient/pages/PossessionClubManagementPage.dart';
import 'package:cptclient/pages/PossessionUserManagementPage.dart';
import 'package:cptclient/pages/SkillOverviewPage.dart';
import 'package:cptclient/pages/StockManagementPage.dart';
import 'package:cptclient/pages/TeamOverviewPage.dart';
import 'package:cptclient/pages/TermOverviewPage.dart';
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
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => MemberProfilePage(session: session))),
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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CalendarMonthPage(
                          session: session,
                        ))),
          ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_course.png'),
            text: AppLocalizations.of(context)!.course,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseAvailable,
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => CourseAvailablePage(session: session))),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCourseResponsible,
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => CourseResponsiblePage(session: session))),
          ),
          if (session.right!.course.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageCourseManagement,
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CourseManagementPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_event.png'),
            text: AppLocalizations.of(context)!.event,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventAvailable,
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => EventOverviewAvailablePage(session: session))),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventOwnership,
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => EventOverviewOwnershipPage(session: session))),
          ),
          if (session.right!.event.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageEventManagement,
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => EventOverviewManagementPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_rankings.png'),
            text: AppLocalizations.of(context)!.competence,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageCompetencePersonal,
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => CompetenceSummaryPage(session: session))),
          ),
          if (session.right!.competence.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageCompetenceManagement,
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CompetenceOverviewPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_teams.png'),
            text: AppLocalizations.of(context)!.team,
          ),
          if (session.right!.team.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageTeamManagement,
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TeamOverviewPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_membership.png'),
            text: AppLocalizations.of(context)!.term,
          ),
          if (session.right!.club.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageClubManagement,
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClubOverviewPage(session: session))),
            ),
          if (session.right!.club.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageTermManagement,
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TermOverviewPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_user.png'),
            text: AppLocalizations.of(context)!.user,
          ),
          if (session.right!.user.write)
            AppButton(
              text: AppLocalizations.of(context)!.pageUserManagement,
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserOverviewPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_inventory.png'),
            text: AppLocalizations.of(context)!.labelInventory,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pagePossessionPersonal,
            onPressed: () => {},
          ),
          if (session.right!.inventory.read)
            AppButton(
              text: AppLocalizations.of(context)!.pagePossessionUser,
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PossessionUserManagementPage(session: session))),
            ),
          if (session.right!.inventory.read)
            AppButton(
              text: AppLocalizations.of(context)!.pagePossessionClub,
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PossessionClubManagementPage(session: session))),
            ),
          if (session.right!.inventory.read)
            AppButton(
              text: AppLocalizations.of(context)!.pageStockManagement,
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => StockManagementPage(session: session))),
            ),
          if (session.right!.inventory.read)
            AppButton(
              text: AppLocalizations.of(context)!.pageItemOverview,
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ItemOverviewPage(session: session))),
            ),
          if (session.right!.inventory.read)
            AppButton(
              text: AppLocalizations.of(context)!.pageItemcatOverview,
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ItemcatOverviewPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_skill.png'),
            text: AppLocalizations.of(context)!.skill,
          ),
          if (session.right!.competence.read)
            AppButton(
              text: AppLocalizations.of(context)!.pageSkillManagement,
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SkillOverviewPage(session: session))),
            ),
          Divider(),
          AppModuleSection(
            image: const AssetImage('assets/icons/icon_location.png'),
            text: AppLocalizations.of(context)!.location,
          ),
          if (session.right!.location.read)
            AppButton(
              text: AppLocalizations.of(context)!.pageLocationManagement,
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LocationOverviewPage(session: session))),
            ),
        ],
      ),
    );
  }
}
