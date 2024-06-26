import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/pages/ClubEditPage.dart';
import 'package:cptclient/pages/ClubStatisticMemberPage.dart';
import 'package:cptclient/pages/ClubStatisticTeamPage.dart';
import 'package:cptclient/static/server_club_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubDetailPage extends StatefulWidget {
  final Session session;
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
        builder: (context) => ClubEditPage(
          session: widget.session,
          club: widget.club,
          isDraft: false,
        ),
      ),
    );
  }

  void _handleDelete() async {
    if (!await api_admin.club_delete(widget.session, widget.club)) return;

    Navigator.pop(context);
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
          AppButton(
            text: AppLocalizations.of(context)!.pageClubStatisticMember,
            onPressed: _handleStatisticMember,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageClubStatisticTeam,
            onPressed: _handleStatisticTeams,
          ),
        ],
      ),
    );
  }
}
