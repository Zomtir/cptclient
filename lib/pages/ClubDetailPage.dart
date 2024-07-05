import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/pages/ClubEditPage.dart';
import 'package:cptclient/pages/ClubStatisticMemberPage.dart';
import 'package:cptclient/pages/ClubStatisticOrganisationPage.dart';
import 'package:cptclient/pages/ClubStatisticTeamPage.dart';
import 'package:cptclient/pages/TermOverviewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  _handleEdit() async {
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
        builder: (context) =>
            TermOverviewPage(
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
        builder: (context) =>
            ClubStatisticMemberPage(
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
        builder: (context) =>
            ClubStatisticTeamPage(
              session: widget.session,
              club: widget.club,
            ),
      ),
    );
  }

  Future<void> _handleStatisticOrganisation() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ClubStatisticOrganisationPage(
              session: widget.session,
              club: widget.club,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubDetails),
      ),
      body: AppBody(
        children: <Widget>[
          AppClubTile(
            club: widget.club,
            trailing: [
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