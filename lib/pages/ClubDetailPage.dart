import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/api/anon/organisation.dart' as api_anon;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/pages/ClubEditPage.dart';
import 'package:cptclient/pages/ClubStatisticMemberPage.dart';
import 'package:cptclient/pages/ClubStatisticOrganisationPage.dart';
import 'package:cptclient/pages/ClubStatisticPresencePage.dart';
import 'package:cptclient/pages/ClubStatisticTeamPage.dart';
import 'package:cptclient/pages/TermOverviewPage.dart';
import 'package:flutter/material.dart';

class ClubDetailPage extends StatefulWidget {
  final UserSession session;
  final Club club;

  ClubDetailPage({super.key, required this.session, required this.club});

  @override
  ClubDetailPageState createState() => ClubDetailPageState();
}

class ClubDetailPageState extends State<ClubDetailPage> {
  ClubDetailPageState();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubEditPage(session: widget.session, club: widget.club, isDraft: false),
      ),
    );
  }

  void _handleDelete() async {
    if (!await api_admin.club_delete(widget.session, widget.club)) return;

    Navigator.pop(context);
  }

  Future<void> _handleTerms() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermOverviewPage(
          session: widget.session,
          club: widget.club,
        ),
      ),
    );
  }

  Future<void> _handleStatisticMember() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubStatisticMemberPage(
          session: widget.session,
          club: widget.club,
        ),
      ),
    );
  }

  Future<void> _handleStatisticTeams() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubStatisticTeamPage(
          session: widget.session,
          club: widget.club,
        ),
      ),
    );
  }

  Future<void> _handleStatisticPresence() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubStatisticPresencePage(
          session: widget.session,
          club: widget.club,
          userID: widget.session.user!.id,
          title:
              '${AppLocalizations.of(context)!.pageClubStatisticPresence} - ${AppLocalizations.of(context)!.eventLeader}',
        ),
      ),
    );
  }

  Future<void> _handleStatisticOrganisation() async {
    List<Organisation> organisations = await api_anon.organisation_list();
    Organisation? organisation;

    await useAppDialog(
      context: context,
      child: PickerDialog(
        items: organisations,
        onPick: (item) => organisation = item,
      ),
    );

    if (organisation == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubStatisticOrganisationPage(
          session: widget.session,
          club: widget.club,
          organisation: organisation!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _handleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          widget.club.buildCard(context),
          MenuSection(
            title: AppLocalizations.of(context)!.term,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageTermManagement),
                onTap: _handleTerms,
              ),
            ],
          ),
          MenuSection(
            title: AppLocalizations.of(context)!.labelStatistics,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageClubStatisticMember),
                onTap: _handleStatisticMember,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageClubStatisticTeam),
                onTap: _handleStatisticTeams,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageClubStatisticPresence),
                onTap: _handleStatisticPresence,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageClubStatisticOrganisation),
                onTap: _handleStatisticOrganisation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
