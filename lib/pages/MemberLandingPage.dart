import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/pages/CalendarDayPage.dart';
import 'package:cptclient/pages/CalendarMonthPage.dart';
import 'package:cptclient/pages/ClubOverviewPage.dart';
import 'package:cptclient/pages/CompetenceOverviewPage.dart';
import 'package:cptclient/pages/CompetenceSummaryPage.dart';
import 'package:cptclient/pages/CourseAvailablePage.dart';
import 'package:cptclient/pages/CourseOverviewManagementPage.dart';
import 'package:cptclient/pages/CourseOverviewModerationPage.dart';
import 'package:cptclient/pages/EventOverviewAvailablePage.dart';
import 'package:cptclient/pages/EventOverviewManagementPage.dart';
import 'package:cptclient/pages/EventOverviewOwnershipPage.dart';
import 'package:cptclient/pages/ItemOverviewPage.dart';
import 'package:cptclient/pages/ItemcatOverviewPage.dart';
import 'package:cptclient/pages/LocationOverviewPage.dart';
import 'package:cptclient/pages/MemberProfilePage.dart';
import 'package:cptclient/pages/OrganisationOverviewPage.dart';
import 'package:cptclient/pages/PossessionClubManagementPage.dart';
import 'package:cptclient/pages/PossessionPersonalPage.dart';
import 'package:cptclient/pages/PossessionUserManagementPage.dart';
import 'package:cptclient/pages/SettingsPage.dart';
import 'package:cptclient/pages/SkillOverviewPage.dart';
import 'package:cptclient/pages/StockManagementPage.dart';
import 'package:cptclient/pages/TeamOverviewPage.dart';
import 'package:cptclient/pages/UserOverviewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MemberLandingPage extends StatelessWidget {
  final UserSession session;

  MemberLandingPage({super.key, required this.session}) {
    if (session.user == null) {
      throw Exception("The member landing page requires a logged-in user.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.labelWelcome} ${session.user!.firstname}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.perm_identity, color: Colors.white),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => MemberProfilePage(session: session))),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => navi.logoutUser(context),
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          MenuSection(
            title: AppLocalizations.of(context)!.labelCalendar,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_calendar.png'),
            ),
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCalendarMonth),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CalendarMonthPage(session: session))),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCalendarDay),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CalendarDayPage(
                              session: session,
                              initialDate: DateTime.now(),
                            ))),
              ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.course,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_course.png'),
            ),
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseAvailable),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CourseAvailablePage(session: session))),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCourseResponsible),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CourseOverviewModerationPage(session: session))),
              ),
              if (session.right!.course.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageCourseManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => CourseOverviewManagementPage(session: session))),
                ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.event,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_event.png'),
            ),
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventAvailable),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => EventOverviewAvailablePage(session: session))),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventOwnership),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => EventOverviewOwnershipPage(session: session))),
              ),
              if (session.right!.event.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageEventManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => EventOverviewManagementPage(session: session))),
                ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.competence,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_competence.png'),
            ),
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageCompetencePersonal),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CompetenceSummaryPage(session: session))),
              ),
              if (session.right!.competence.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageCompetenceManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => CompetenceOverviewPage(session: session))),
                ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.team,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_team.png'),
            ),
            children: [
              if (session.right!.team.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageTeamManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => TeamOverviewPage(session: session))),
                ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.term,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_membership.png'),
            ),
            children: [
              if (session.right!.club.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageClubManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ClubOverviewPage(session: session))),
                ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.user,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_user.png'),
            ),
            children: [
              if (session.right!.user.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageUserManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => UserOverviewPage(session: session))),
                ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.labelInventory,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_inventory.png'),
            ),
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pagePossessionPersonal),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PossessionPersonalPage(session: session))),
              ),
              if (session.right!.inventory.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pagePossessionUser),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => PossessionUserManagementPage(session: session))),
                ),
              if (session.right!.inventory.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pagePossessionClub),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => PossessionClubManagementPage(session: session))),
                ),
              if (session.right!.inventory.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageStockManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => StockManagementPage(session: session))),
                ),
              if (session.right!.inventory.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageItemOverview),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ItemOverviewPage(session: session))),
                ),
              if (session.right!.inventory.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageItemcatOverview),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ItemcatOverviewPage(session: session))),
                ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.skill,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_skill.png'),
            ),
            children: [
              if (session.right!.competence.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageSkillManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SkillOverviewPage(session: session))),
                ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.location,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_location.png'),
            ),
            children: [
              if (session.right!.location.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageLocationManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => LocationOverviewPage(session: session))),
                ),
            ],
          ),
          Divider(),
          MenuSection(
            title: AppLocalizations.of(context)!.organisation,
            icon: Image(
              width: 40,
              alignment: Alignment.center,
              image: const AssetImage('assets/icons/icon_organisation.png'),
            ),
            children: [
              if (session.right!.organisation.read)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.pageOrganisationManagement),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => OrganisationOverviewPage(session: session))),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
