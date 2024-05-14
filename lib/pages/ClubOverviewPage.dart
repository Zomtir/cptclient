import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/pages/ClubDetailPage.dart';
import 'package:cptclient/pages/ClubEditPage.dart';
import 'package:cptclient/static/server_club_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubOverviewPage extends StatefulWidget {
  final Session session;

  ClubOverviewPage({super.key, required this.session});

  @override
  ClubOverviewPageState createState() => ClubOverviewPageState();
}

class ClubOverviewPageState extends State<ClubOverviewPage> {
  GlobalKey<SearchablePanelState<Club>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Club> clubs = await api_admin.club_list(widget.session);
    searchPanelKey.currentState?.setItems(clubs);
  }

  void _handleSelect(Club club) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubDetailPage(
          session: widget.session,
          club: club,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubEditPage(
          session: widget.session,
          club: Club.fromVoid(),
          isDraft: true,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubManagement),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
          SearchablePanel(
            key: searchPanelKey,
            builder: (Club club, Function(Club)? onSelect) => InkWell(
              onTap: () => onSelect?.call(club),
              child: club.buildTile(),
            ),
            onSelect: _handleSelect,
          )
        ],
      ),
    );
  }
}
